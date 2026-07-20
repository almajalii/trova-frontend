import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/project-detail/presentation/screens/my_projects_screen.dart';
import 'package:trova/features/project-history/logic/project_history_service.dart';
import 'package:trova/features/project-history/presentation/bloc/project_history_bloc.dart';
import 'package:trova/features/project-history/presentation/bloc/project_history_event.dart';
import 'package:trova/features/project-history/presentation/bloc/project_history_state.dart';
import 'package:trova/features/project-history/presentation/widget/project_history_layout.dart';

class ProjectHistoryScreen extends StatelessWidget {
  const ProjectHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            ProjectHistoryBloc(projectHistoryService: sl<ProjectHistoryService>())
              ..add(const ProjectHistoryLoadRequested()),
        child: BlocConsumer<ProjectHistoryBloc, ProjectHistoryState>(
          listener: (context, state) {
            if (state is ProjectHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProjectHistoryLoading || state is ProjectHistoryInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProjectHistoryError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(state.message, textAlign: TextAlign.center),
                ),
              );
            }

            final projects = (state as ProjectHistoryLoaded).projects;
            return ProjectHistoryLayout(
              projects: projects,
              onBack: () => Navigator.of(context).maybePop(),
              onRefresh: () async => context.read<ProjectHistoryBloc>().add(const ProjectHistoryLoadRequested()),
              onProjectTap: (project) => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => ProjectDetailScreen(projectId: project.id))),
            );
          },
        ),
      ),
    );
  }
}
