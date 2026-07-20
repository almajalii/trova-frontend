import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/success_badge.dart';
import 'package:trova/features/guarantee-review/presentation/screens/review_guarantee_screen.dart';
import 'package:trova/features/project-detail/presentation/screens/my_projects_screen.dart';
import 'package:trova/features/review-work/presentation/screens/review_submitted_work_screen.dart';
import 'package:trova/features/my-projects/logic/my_projects_model.dart';
import 'package:trova/features/my-projects/logic/my_projects_service.dart';
import 'package:trova/features/my-projects/presentation/bloc/my_projects_bloc.dart';
import 'package:trova/features/my-projects/presentation/bloc/my_projects_event.dart';
import 'package:trova/features/my-projects/presentation/bloc/my_projects_state.dart';
import 'package:trova/features/my-projects/presentation/widget/my_projects_layout.dart';
import 'package:trova/features/post-project/presentation/screens/post_a_project_screen.dart';
import 'package:trova/features/project-history/presentation/screens/project_history_screen.dart';

class MyProjectsScreen extends StatelessWidget {
  const MyProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => MyProjectsBloc(myProjectsService: sl<MyProjectsService>())..add(const MyProjectsLoadRequested()),
        child: BlocConsumer<MyProjectsBloc, MyProjectsState>(
          listener: (context, state) {
            if (state is MyProjectsError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is MyProjectsLoading || state is MyProjectsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyProjectsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            final projects = (state as MyProjectsLoaded).projects;
            return MyProjectsLayout(
              projects: projects,
              onRefresh: () async => context.read<MyProjectsBloc>().add(const MyProjectsLoadRequested()),
              onAddPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostAProjectScreen())),
              onHistoryPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProjectHistoryScreen())),
              onProjectTap: (project) => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id))),
              onActionPressed: (project) {
                // Awarded cards' button is "Review Guarantee" — goes straight to the
                // approve/reject screen. Pending Review cards' button is "Review Work"
                // — goes straight to the confirm/flag screen. Every other status's
                // action (Post Project Again) doesn't have its own screen yet, so it
                // falls back to Project Detail for now.
                if (project.status == ProjectStatus.awarded) {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => ReviewGuaranteeScreen(projectId: project.id)));
                  return;
                }
                if (project.status == ProjectStatus.pendingReview) {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => ReviewSubmittedWorkScreen(projectId: project.id)));
                  return;
                }
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id)));
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const TrovaBottomNav(activeIndex: 1),
    );
  }
}
