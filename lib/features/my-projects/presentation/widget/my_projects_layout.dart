import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/my-projects/logic/my_projects_model.dart';
import 'package:trova/features/my-projects/presentation/widget/project_card.dart';

class MyProjectsLayout extends StatelessWidget {
  final List<ProjectSummary> projects;
  final VoidCallback onAddPressed;
  final VoidCallback onHistoryPressed;
  final ValueChanged<ProjectSummary> onProjectTap;
  final ValueChanged<ProjectSummary>? onActionPressed;
  final Future<void> Function()? onRefresh;

  const MyProjectsLayout({
    super.key,
    required this.projects,
    required this.onAddPressed,
    required this.onHistoryPressed,
    required this.onProjectTap,
    this.onActionPressed,
    this.onRefresh,
  });

  // Fixed display order for sections; a group is only rendered — and
  // numbered — if it has at least one project in it.
  static const _groupOrder = [
    ProjectStatusGroup.awaitingBids,
    ProjectStatusGroup.awarded,
    ProjectStatusGroup.inExecution,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final grouped = <ProjectStatusGroup, List<ProjectSummary>>{};
    for (final group in _groupOrder) {
      grouped[group] = projects.where((p) => p.status.group == group).toList();
    }

    final list = ListView(
      padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 4, bottom: 32),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              text: 'My Projects',
              textSize: 22,
              fontWeight: FontWeight.w700,
              textColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: onHistoryPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(20)),
                    child: AppText(
                      text: 'History',
                      textSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onAddPressed,
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (projects.isEmpty) _EmptyState(colors: colors) else _buildSections(grouped, colors),
      ],
    );

    if (onRefresh == null) return list;
    return RefreshIndicator(onRefresh: onRefresh!, child: list);
  }

  Widget _buildSections(Map<ProjectStatusGroup, List<ProjectSummary>> grouped, ColorScheme colors) {
    final sections = <Widget>[];
    var sectionNumber = 0;

    for (final group in _groupOrder) {
      final items = grouped[group]!;
      if (items.isEmpty) continue;
      sectionNumber++;

      sections.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8, top: sectionNumber == 1 ? 0 : 20),
          child: AppText(
            text: '$sectionNumber. ${group.sectionTitle}',
            textSize: 12,
            fontWeight: FontWeight.w600,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.start,
          ),
        ),
      );

      for (var i = 0; i < items.length; i++) {
        sections.add(
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: ProjectCard(
              project: items[i],
              onTap: () => onProjectTap(items[i]),
              onActionPressed: onActionPressed == null ? null : () => onActionPressed!(items[i]),
            ),
          ),
        );
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: sections);
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 40, color: colors.onSurfaceVariant),
          const SizedBox(height: 12),
          AppText(
            text: "You haven't posted any projects yet.",
            textSize: 14,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
