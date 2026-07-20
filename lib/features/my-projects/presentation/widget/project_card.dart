import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/my-projects/logic/my_projects_model.dart';

/// One project card on the My Projects list. Content shifts based on
/// [ProjectSummary.status] — badge color, an optional guarantee strip,
/// an optional danger-toned note, and an optional full-width action
/// button — but it's a single widget rather than six near-duplicates.
class ProjectCard extends StatelessWidget {
  final ProjectSummary project;
  final VoidCallback onTap;
  final VoidCallback? onActionPressed;

  const ProjectCard({super.key, required this.project, required this.onTap, this.onActionPressed});

  (Color bg, Color fg) _badgeColors(ColorScheme colors) {
    switch (project.status) {
      case ProjectStatus.openForBids:
      case ProjectStatus.inProgress:
        return (AppColors.primaryTint, colors.primary);
      case ProjectStatus.awarded:
        return (AppColors.successBg, AppColors.success);
      case ProjectStatus.contractorBackedOff:
      case ProjectStatus.guaranteeRejectedByYou:
        return (AppColors.dangerBg, AppColors.danger);
      case ProjectStatus.pendingReview:
        return (AppColors.warningBg, AppColors.warning);
    }
  }

  (Color bg, Color fg) _stripColors(GuaranteeStripTone tone) {
    switch (tone) {
      case GuaranteeStripTone.success:
        return (AppColors.successBg, AppColors.success);
      case GuaranteeStripTone.warning:
        return (AppColors.warningBg, AppColors.warning);
    }
  }

  /// "JOD 1.2M" / "JOD 240K" — matches the Figma abbreviation style.
  String _formatValue(double jod) {
    if (jod >= 1000000) {
      final m = jod / 1000000;
      return 'JOD ${m == m.roundToDouble() ? m.toStringAsFixed(0) : m.toStringAsFixed(1)}M';
    }
    if (jod >= 1000) {
      return 'JOD ${(jod / 1000).round()}K';
    }
    return 'JOD ${jod.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (badgeBg, badgeFg) = _badgeColors(colors);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: colors.surfaceBright),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    text: project.title,
                    textSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.onSurface,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 8),
                StatusPill(text: project.status.label, background: badgeBg, foreground: badgeFg, fontSize: 11),
              ],
            ),
            const SizedBox(height: 8),
            AppText(
              text: '${_formatValue(project.contractValueJod)} · ${project.detailText}',
              textSize: 12,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),
            if (project.note != null) ...[
              const SizedBox(height: 6),
              AppText(text: project.note!, textSize: 12, textColor: AppColors.danger, textAlign: TextAlign.start),
            ],
            if (project.guaranteeStripLabel != null && project.guaranteeStripTone != null) ...[
              const SizedBox(height: 8),
              Builder(
                builder: (context) {
                  final (stripBg, stripFg) = _stripColors(project.guaranteeStripTone!);
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(color: stripBg, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            text: project.guaranteeStripLabel!,
                            textSize: 12,
                            fontWeight: FontWeight.w600,
                            textColor: stripFg,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        if (project.guaranteeStripSubtext != null) ...[
                          const SizedBox(width: 8),
                          AppText(
                            text: project.guaranteeStripSubtext!,
                            textSize: 11,
                            textColor: stripFg,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ],
            if (project.actionLabel != null) ...[
              const SizedBox(height: 8),
              Button(
                text: project.actionLabel!,
                textColor: colors.onPrimary,
                borderRadius: 8,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: double.infinity,
                buttonHeight: 42,
                onPressed: onActionPressed ?? onTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
