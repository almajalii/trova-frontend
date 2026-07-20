import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/bidders/presentation/screens/bidders_list_screen.dart';
import 'package:trova/features/guarantee-review/presentation/screens/guarantee_document_screen.dart';
import 'package:trova/features/guarantee-review/presentation/screens/review_guarantee_screen.dart';
import 'package:trova/features/review-work/presentation/screens/review_submitted_work_screen.dart';
import 'package:trova/features/repost-project/presentation/screens/repost_project_screen.dart';
import 'package:trova/features/project-detail/logic/project_detail_model.dart';
import 'package:trova/features/project-detail/logic/project_detail_service.dart';
import 'package:trova/features/project-detail/presentation/bloc/project_detail_bloc.dart';
import 'package:trova/features/project-detail/presentation/bloc/project_detail_event.dart';
import 'package:trova/features/project-detail/presentation/bloc/project_detail_state.dart';
import 'package:trova/features/project-detail/presentation/widget/project_detail_layout.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            ProjectDetailBloc(projectDetailService: sl<ProjectDetailService>())
              ..add(ProjectDetailLoadRequested(projectId: projectId)),
        child: BlocConsumer<ProjectDetailBloc, ProjectDetailState>(
          listener: (context, state) {
            if (state is ProjectDetailError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProjectDetailLoading || state is ProjectDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProjectDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            final project = (state as ProjectDetailLoaded).project;

            return ProjectDetailLayout(
              project: project,
              onBack: () => Navigator.of(context).maybePop(),
              onRefresh: () async =>
                  context.read<ProjectDetailBloc>().add(ProjectDetailLoadRequested(projectId: projectId)),
              // Tapping the "Guarantee" row: Awarded means it's pending your review;
              // In Progress / Pending Review / Failed means it's already issued
              // (active or claimed) — both variants render from the same
              // GuaranteeDocumentScreen. (Pending Review here refers to the
              // contractor's submitted work, not the guarantee — the guarantee
              // itself is already active by that point.)
              // NOTE: Completed/Disputed projects also show a guarantee line ("Expired
              // · No claims" / "Active · Held pending dispute") but that's a state this
              // model doesn't cover yet (only pendingReview/active/rejected/claimed) —
              // left non-tappable until an "expired" status + demo data are added.
              onGuaranteeRowTap: switch (project.status) {
                DetailStatus.awarded => () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => ReviewGuaranteeScreen(projectId: project.id))),
                DetailStatus.inProgress ||
                DetailStatus.pendingReview ||
                DetailStatus.failed => () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => GuaranteeDocumentScreen(projectId: project.id))),
                _ => null,
              },
              onActionPressed: switch (project.status) {
                DetailStatus.openForBids => () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BiddersListScreen(projectId: project.id, projectTitle: project.title),
                  ),
                ),
                DetailStatus.awarded => () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => ReviewGuaranteeScreen(projectId: project.id))),
                DetailStatus.pendingReview => () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => ReviewSubmittedWorkScreen(projectId: project.id))),
                DetailStatus.failed => () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => GuaranteeDocumentScreen(projectId: project.id))),
                DetailStatus.contractorBackedOff ||
                DetailStatus.guaranteeRejectedByYou => () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => RepostProjectScreen(projectId: project.id))),
                _ => () {
                  // TODO: route to the right screen per project.actionLabel once each
                  // exists — View Dispute Status. Next increments.
                },
              },
            );
          },
        ),
      ),
    );
  }
}
