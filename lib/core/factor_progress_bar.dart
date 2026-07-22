import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';

/// Labelled horizontal progress bar — Score Breakdown rows on My Score.
class FactorProgressBar extends StatelessWidget {
  final String label;
  final int percentage;
  final String? description;

  const FactorProgressBar({super.key, required this.label, required this.percentage, this.description});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: label, textSize: 13, textColor: colors.onSurface),
            AppText(text: '$percentage%', textSize: 13, fontWeight: FontWeight.w600, textColor: colors.primary),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: AppColors.neutralStatBg,
            color: colors.primary,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 6),
          AppText(text: description!, textSize: 11, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
        ],
      ],
    );
  }
}
