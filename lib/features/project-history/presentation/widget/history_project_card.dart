import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/contractor_tap_target.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/project-history/logic/project_history_model.dart';

/// One project card on the Project History screen. Simpler than
/// my-projects' ProjectCard — no action button, no separate note field —
/// since Completed/Disputed/Failed are all terminal states. The optional
/// strip's color always follows the status tone (unlike ProjectCard,
/// there's no independent tone field to plumb through).
class HistoryProjectCard extends StatelessWidget {
  final HistoryProjectSummary project;
  final VoidCallback onTap;

  const HistoryProjectCard({super.key, required this.project, required this.onTap});

  (Color bg, Color fg) _tone(ColorScheme colors) {
    switch (project.status) {
      case HistoryProjectStatus.completed:
        return (AppColors.neutralTagBg, colors.onSurfaceVariant);
      case HistoryProjectStatus.disputed:
        return (AppColors.warningBg, AppColors.warning);
      case HistoryProjectStatus.failed:
        return (AppColors.dangerBg, AppColors.danger);
      case HistoryProjectStatus.cancelled:
        // Neutral, same as completed — being reposted isn't a bad
        // outcome, just a terminal one for this particular project.
        return (AppColors.neutralTagBg, colors.onSurfaceVariant);
    }
  }

  /// "JOD 1.2M" / "JOD 240K" — same abbreviation style as my-projects' card.
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
    final (tone, fg) = _tone(colors);

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
                StatusPill(text: project.status.label, background: tone, foreground: fg, fontSize: 11),
              ],
            ),
            const SizedBox(height: 8),
            ContractorTapTarget(
              contractor: project.awardedBidder,
              child: AppText(
                text: '${_formatValue(project.contractValueJod)} · ${project.detailText}',
                textSize: 12,
                textColor: project.awardedBidder != null ? colors.primary : colors.onSurfaceVariant,
                textAlign: TextAlign.start,
              ),
            ),
            if (project.guaranteeStripLabel != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: tone, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        text: project.guaranteeStripLabel!,
                        textSize: 12,
                        fontWeight: FontWeight.w600,
                        textColor: fg,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (project.guaranteeStripSubtext != null) ...[
                      const SizedBox(width: 8),
                      AppText(
                        text: project.guaranteeStripSubtext!,
                        textSize: 11,
                        textColor: fg,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
