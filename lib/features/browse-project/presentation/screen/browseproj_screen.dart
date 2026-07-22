import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';
import 'package:trova/features/browse-project/logic/browseproj_service.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_bloc.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_event.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_state.dart';
import 'package:trova/features/browse-project/presentation/widget/project_page.dart';

class BrowseProjectsScreen extends StatelessWidget {
  const BrowseProjectsScreen({super.key});

  static const _sectors = ['All', 'Construction', 'Real Estate', 'Infrastructure'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProjectsBloc(service: sl<ProjectsService>())..add(const FetchProjects()),
        child: SafeArea(
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

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back, color: colors.onSurface),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),

                    const SizedBox(height: 8),

                    AppTitle(
                      title: 'Open Projects',
                      size: 22,
                      weight: FontWeight.bold,
                      titleColor: colors.onSurface,
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(height: 4),

                    if (state is ProjectsSuccess)
                      AppText(
                        text:
                            '${state.projects.length} of ${state.projects.length} projects match your classification and score.',
                        textSize: 13,
                        textColor: colors.onSurfaceVariant,
                        textAlign: TextAlign.left,
                      ),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _sectors.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final sector = _sectors[index];
                          final currentSector = state is ProjectsSuccess ? state.filter.sector : null;
                          final isSelected = sector == 'All' ? currentSector == null : currentSector == sector;

                          return ChoiceChip(
                            label: Text(sector),
                            selected: isSelected,
                            onSelected: (_) {
                              final baseFilter = state is ProjectsSuccess ? state.filter : const ProjectsFilter();
                              final newFilter = ProjectsFilter(
                                sector: sector == 'All' ? null : sector,
                                minValue: baseFilter.minValue,
                                maxValue: baseFilter.maxValue,
                                sortBy: baseFilter.sortBy,
                              );
                              context.read<ProjectsBloc>().add(ApplyFilters(newFilter));
                            },
                            selectedColor: colors.primary,
                            backgroundColor: colors.surfaceBright,
                            labelStyle: TextStyle(
                              color: isSelected ? colors.onPrimary : colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: StadiumBorder(side: BorderSide(color: colors.surfaceBright)),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    Expanded(
                      child: Builder(builder: (context) {
                        if (state is ProjectsInitial || state is ProjectsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (state is ProjectsError) {
                          return Center(child: AppText(text: state.message));
                        }
                        final successState = state as ProjectsSuccess;
                        return ProjectsListView(
                          projects: successState.projects,
                          onBidTap: (project) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.projectDetail,
                                  arguments: project.projectId,
                                );

                          },
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}