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
import 'package:trova/features/repost-project/presentation/screens/repost_project_screen.dart';

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

            void refresh() => context.read<MyProjectsBloc>().add(const MyProjectsLoadRequested());

            return MyProjectsLayout(
              projects: projects,
              onRefresh: () async => refresh(),
              onAddPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const PostAProjectScreen()))
                  .then((_) => refresh()),
              onHistoryPressed: () =>
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProjectHistoryScreen())),
              onProjectTap: (project) => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id)))
                  .then((_) => refresh()),
              onActionPressed: (project) {
                if (project.status == ProjectStatus.awarded) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ReviewGuaranteeScreen(projectId: project.id)))
                      .then((_) => refresh());
                  return;
                }
                if (project.status == ProjectStatus.pendingReview) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => ReviewSubmittedWorkScreen(projectId: project.id)))
                      .then((_) => refresh());
                  return;
                }
                if (project.status == ProjectStatus.contractorBackedOff ||
                    project.status == ProjectStatus.guaranteeRejectedByYou) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => RepostProjectScreen(projectId: project.id)))
                      .then((_) => refresh());
                  return;
                }
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id)))
                    .then((_) => refresh());
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const TrovaBottomNav(activeIndex: 1),
    );
  }
}
