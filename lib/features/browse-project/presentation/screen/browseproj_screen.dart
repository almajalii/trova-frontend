import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';
import 'package:trova/features/browse-project/logic/browseproj_service.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_bloc.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_event.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_state.dart';
import 'package:trova/features/browse-project/presentation/widget/browseproj_filter.dart';
import 'package:trova/features/browse-project/presentation/widget/project_page.dart';


class BrowseProjectsScreen extends StatelessWidget {
  const BrowseProjectsScreen({super.key});

  Future<void> _openFilterSheet(BuildContext context, ProjectsFilter currentFilter) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterProjectsSheet(initialFilter: currentFilter),
    );

    if (result != null) {
      context.read<ProjectsBloc>().add(ApplyFilters(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Projects')),
      body: BlocProvider(
        create: (_) => ProjectsBloc(service: sl<ProjectsService>())..add(const FetchProjects()),
        child: BlocConsumer<ProjectsBloc, ProjectsState>(
          listener: (context, state) {
            if (state is ProjectsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final colors = Theme.of(context).colorScheme;

            if (state is ProjectsInitial || state is ProjectsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProjectsError) {
              return Center(child: AppText(text: state.message));
            }

            final successState = state as ProjectsSuccess;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppTitle(
                        title: 'Open Projects',
                        size: 20,
                        weight: FontWeight.bold,
                        titleColor: colors.onSurface,
                        textAlign: TextAlign.left,
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () => _openFilterSheet(context, successState.filter),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text:
                        '${successState.projects.length} of ${successState.projects.length} projects match your classification and score.',
                    textSize: 13,
                    textColor: colors.onSurfaceVariant,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ProjectsListView(
                      projects: successState.projects,
                      onBidTap: (project) {
                        // TODO: navigate to ProjectDetailScreen(projectId: project.id)
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}