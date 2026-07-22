// lib/features/biddetail/presentation/widget/detail_info_card.dart

import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';

class DetailInfoCard extends StatelessWidget {
  final List<MapEntry<String, String>> rows;

  const DetailInfoCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceBright),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final isLast = entry.key == rows.length - 1;
          final row = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(bottom: BorderSide(color: colors.surfaceBright)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    text: row.key,
                    textSize: 13,
                    textColor: colors.secondary.withValues(alpha: 0.6),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: AppText(
                    text: row.value,
                    textSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: colors.onSurface,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}