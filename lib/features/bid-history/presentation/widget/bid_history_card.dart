import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/features/bid-history/logic/bid_history_model.dart';

class BidHistoryCard extends StatelessWidget {
  final BidHistoryModel bid;
  final VoidCallback? onTap;

  const BidHistoryCard({super.key, required this.bid, this.onTap});

  _StatusStyle get _style {
    switch (bid.status) {
      case 'completed':
        return _StatusStyle('Completed', const Color(0xFFDFF3E3), const Color(0xFF1E8E3E));
      case 'rejected':
        return _StatusStyle('Rejected', const Color(0xFFF1F1F1), const Color(0xFF5F6368));
      case 'backedOff':
        return _StatusStyle('Backed Off', const Color(0xFFFDE8E8), const Color(0xFFC82333));
      default:
        return _StatusStyle(bid.status, const Color(0xFFF1F1F1), const Color(0xFF5F6368));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = _style;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.surfaceBright),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppText(
                    text: bid.projectTitle,
                    fontWeight: FontWeight.bold,
                    textSize: 15,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: style.bg, borderRadius: BorderRadius.circular(20)),
                  child: AppText(
                    text: style.label,
                    textSize: 11,
                    fontWeight: FontWeight.w600,
                    textColor: style.text,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            AppText(
              text: '${bid.companyName} · JOD ${bid.bidAmount.toStringAsFixed(0)}',
              textSize: 13,
              textColor: colors.secondary.withValues(alpha: 0.6),
              textAlign: TextAlign.start,
            ),
            if (bid.note != null) ...[
              const SizedBox(height: 8),
              AppText(
                text: bid.note!,
                textSize: 12,
                textColor: colors.secondary.withValues(alpha: 0.6),
                textAlign: TextAlign.start,
              ),
            ],
            if (bid.reviewText != null) ...[
              const SizedBox(height: 10),
              Container(height: 1, color: colors.surfaceBright),
              const SizedBox(height: 10),
              Row(
                children: [
                  AppText(
                    text: 'Review Received',
                    textSize: 12,
                    fontWeight: FontWeight.w600,
                    textColor: colors.onSurface,
                  ),
                  const SizedBox(width: 8),
                  if (bid.reviewRating != null)
                    AppText(
                      text: '★' * bid.reviewRating! + '☆' * (5 - bid.reviewRating!),
                      textSize: 13,
                      textColor: const Color(0xFFB8760B),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              AppText(
                text: '"${bid.reviewText!}"',
                textSize: 12,
                textColor: colors.secondary.withValues(alpha: 0.7),
                textAlign: TextAlign.start,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusStyle {
  final String label;
  final Color bg;
  final Color text;
  const _StatusStyle(this.label, this.bg, this.text);
}
