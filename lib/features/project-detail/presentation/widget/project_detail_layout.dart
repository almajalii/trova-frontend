import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/project-detail/logic/project_detail_model.dart';
import 'package:trova/features/project-detail/presentation/widget/detail_timeline_stepper.dart';

class ProjectDetailLayout extends StatelessWidget {
  final ProjectDetail project;
  final VoidCallback onBack;
  final VoidCallback? onActionPressed;
  final VoidCallback? onGuaranteeRowTap;
  final Future<void> Function()? onRefresh;

  const ProjectDetailLayout({
    super.key,
    required this.project,
    required this.onBack,
    this.onActionPressed,
    this.onGuaranteeRowTap,
    this.onRefresh,
  });

  (Color bg, Color fg) _badgeColors(ColorScheme colors) {
    switch (project.status) {
      case DetailStatus.openForBids:
      case DetailStatus.inProgress:
        return (AppColors.primaryTint, colors.primary);
      case DetailStatus.awarded:
        return (AppColors.successBg, AppColors.success);
      case DetailStatus.contractorBackedOff:
      case DetailStatus.guaranteeRejectedByYou:
      case DetailStatus.failed:
        return (AppColors.dangerBg, AppColors.danger);
      case DetailStatus.pendingReview:
      case DetailStatus.disputed:
        return (AppColors.warningBg, AppColors.warning);
      case DetailStatus.completed:
        return (AppColors.neutralTagBg, colors.onSurfaceVariant);
    }
  }

  /// "JOD 1,200,000" — full comma-grouped figure, matching the detail
  /// screen's info card (unlike the list cards, which abbreviate to K/M).
  String _formatValue(double jod) {
    final digits = jod.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return 'JOD $buffer';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (badgeBg, badgeFg) = _badgeColors(colors);

    final list = ListView(
      padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 4, bottom: 32),
      children: [
        GestureDetector(
          onTap: onBack,
          child: Icon(Icons.arrow_back, color: colors.onSurface, size: 22),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppText(
                text: project.title,
                textSize: 19,
                fontWeight: FontWeight.w700,
                textColor: colors.onSurface,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(width: 8),
            StatusPill(text: project.statusLabel, background: badgeBg, foreground: badgeFg, fontSize: 11),
          ],
        ),
        if (project.subtitle != null) ...[
          const SizedBox(height: 8),
          AppText(
            text: project.subtitle!,
            textSize: 13,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.start,
          ),
        ],
        const SizedBox(height: 18),
        _InfoCard(project: project, colors: colors, formatValue: _formatValue, onGuaranteeRowTap: onGuaranteeRowTap),
        const SizedBox(height: 18),
        AppText(
          text: 'Project Timeline',
          textSize: 14,
          fontWeight: FontWeight.w600,
          textColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        DetailTimelineStepper(steps: project.timeline),
        if (project.actionLabel != null) ...[
          const SizedBox(height: 24),
          Button(
            text: project.actionLabel!,
            textColor: Colors.white,
            borderRadius: 10,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            elevation: 0,
            buttonWidth: double.infinity,
            buttonHeight: context.buttonSizeH,
            buttonColor: project.actionIsDanger ? AppColors.danger : colors.primary,
            onPressed: onActionPressed,
          ),
        ],
      ],
    );

    if (onRefresh == null) return list;
    return RefreshIndicator(onRefresh: onRefresh!, child: list);
  }
}

class _InfoCard extends StatelessWidget {
  final ProjectDetail project;
  final ColorScheme colors;
  final String Function(double) formatValue;
  final VoidCallback? onGuaranteeRowTap;

  const _InfoCard({required this.project, required this.colors, required this.formatValue, this.onGuaranteeRowTap});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _InfoRow(label: 'Sector', value: project.sector, colors: colors),
      _InfoRow(label: 'Contract Value', value: formatValue(project.contractValueJod), colors: colors),
      _InfoRow(label: 'Location', value: project.location, colors: colors),
      _InfoRow(label: 'Timeline', value: project.timelineText, colors: colors),
      if (project.milestones != null) _InfoRow(label: 'Milestones', value: project.milestones!, colors: colors),
      _InfoRow(label: 'Guarantee Type Required', value: project.guaranteeTypeRequired, colors: colors),
      _InfoRow(label: 'Payment Terms', value: project.paymentTerms, colors: colors),
      _InfoRow(label: 'Project ID', value: project.projectId, colors: colors),
      if (project.guaranteeRowText != null)
        onGuaranteeRowTap != null
            ? GestureDetector(
                onTap: onGuaranteeRowTap,
                child: _InfoRow(
                  label: 'Guarantee',
                  value: project.guaranteeRowText!,
                  colors: colors,
                  showChevron: true,
                ),
              )
            : _InfoRow(label: 'Guarantee', value: project.guaranteeRowText!, colors: colors),
      if (project.biddersRowText != null) _InfoRow(label: 'Bidders', value: project.biddersRowText!, colors: colors),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[rows[i], if (i != rows.length - 1) const SizedBox(height: 10)],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colors;
  final bool showChevron;

  const _InfoRow({required this.label, required this.value, required this.colors, this.showChevron = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: label, textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(
            text: value,
            textSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.onSurface,
            textAlign: TextAlign.end,
          ),
        ),
        if (showChevron) ...[
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 16, color: colors.onSurfaceVariant),
        ],
      ],
    );
  }
}
