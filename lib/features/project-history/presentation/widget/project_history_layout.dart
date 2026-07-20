import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/project-history/logic/project_history_model.dart';
import 'package:trova/features/project-history/presentation/widget/history_project_card.dart';

class ProjectHistoryLayout extends StatelessWidget {
  final List<HistoryProjectSummary> projects;
  final VoidCallback onBack;
  final ValueChanged<HistoryProjectSummary> onProjectTap;
  final Future<void> Function()? onRefresh;

  const ProjectHistoryLayout({
    super.key,
    required this.projects,
    required this.onBack,
    required this.onProjectTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final list = ListView(
      padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 4, bottom: 32),
      children: [
        GestureDetector(
          onTap: onBack,
          child: Icon(Icons.arrow_back, color: colors.onSurface, size: 22),
        ),
        const SizedBox(height: 20),
        AppText(
          text: 'Project History',
          textSize: 22,
          fontWeight: FontWeight.w700,
          textColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 6),
        AppText(
          text: 'Completed, disputed, and failed projects.',
          textSize: 13,
          textColor: colors.onSurfaceVariant,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        if (projects.isEmpty)
          _EmptyState(colors: colors)
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final project in projects)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: HistoryProjectCard(project: project, onTap: () => onProjectTap(project)),
                ),
            ],
          ),
      ],
    );

    if (onRefresh == null) return list;
    return RefreshIndicator(onRefresh: onRefresh!, child: list);
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
          Icon(Icons.history, size: 40, color: colors.onSurfaceVariant),
          const SizedBox(height: 12),
          AppText(
            text: "No completed, disputed, or failed projects yet.",
            textSize: 14,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
