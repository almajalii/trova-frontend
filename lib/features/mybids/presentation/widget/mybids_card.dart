import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/owner_tap_target.dart';
import 'package:trova/features/mybids/logic/mybid_model.dart';

class BidCard extends StatelessWidget {
  final BidModel bid;
  final VoidCallback? onTap;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final VoidCallback? onBackOffAction;

  const BidCard({
    super.key,
    required this.bid,
    this.onTap,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.onBackOffAction,
  });

  _StatusStyle get _style {
    switch (bid.status) {
      case 'pending':
        return _StatusStyle(label: 'Pending', bg: const Color(0xFFFCEFD8), text: const Color(0xFFB8760B));
      case 'selected':
        return _StatusStyle(label: 'Selected', bg: const Color(0xFFDFF3E3), text: const Color(0xFF1E8E3E));
      case 'confirmed':
        return _StatusStyle(label: 'Confirmed', bg: const Color(0xFFDFF3E3), text: const Color(0xFF1E8E3E));
      case 'guaranteePendingReview':
        return _StatusStyle(label: 'Pending Bank Review', bg: const Color(0xFFFCEFD8), text: const Color(0xFFB8760B));
      case 'guaranteeIssued':
        return _StatusStyle(label: 'Awaiting Owner Confirmation', bg: const Color(0xFFFCEFD8), text: const Color(0xFFB8760B));
      case 'inProgress':
        return _StatusStyle(label: 'In Progress', bg: const Color(0xFFFCEFD8), text: const Color(0xFFB8760B));
      case 'workSubmitted':
        return _StatusStyle(label: 'Awaiting Owner Review', bg: const Color(0xFFDFF3E3), text: const Color(0xFF1E8E3E));
      case 'guaranteeRejected':
        return _StatusStyle(label: 'Guarantee Rejected', bg: const Color(0xFFFDE8E8), text: const Color(0xFFC82333));
      default:
        return _StatusStyle(label: bid.status, bg: const Color(0xFFDFF3E3), text: const Color(0xFF1E8E3E));
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
            Row(
              children: [
                OwnerTapTarget(
                  bidId: bid.id,
                  companyName: bid.companyName,
                  child: AppText(
                    text: bid.companyName,
                    textSize: 13,
                    fontWeight: FontWeight.w600,
                    textColor: colors.primary,
                    textAlign: TextAlign.start,
                  ),
                ),
                AppText(
                  text: ' · Bid JOD ${bid.bidAmount.toStringAsFixed(0)}',
                  textSize: 13,
                  textColor: colors.secondary.withValues(alpha: 0.6),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (bid.status == 'inProgress')
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEFD8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: bid.note ?? '', textSize: 12, fontWeight: FontWeight.w600, textColor: const Color(0xFFB8760B)),
                    AppText(
                      text: 'Expires in ${bid.guaranteeExpiresInDays} days',
                      textSize: 12,
                      textColor: const Color(0xFFB8760B),
                    ),
                  ],
                ),
              )
            else
              AppText(
                text: bid.status == 'workSubmitted' ? 'Waiting for the owner to confirm your work.' : (bid.note ?? ''),
                textSize: 12,
                textColor: bid.status == 'guaranteeRejected' ? const Color(0xFFC82333) : colors.secondary.withValues(alpha: 0.6),
                textAlign: TextAlign.start,
              ),

            const SizedBox(height: 12),

            _buildActions(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(ColorScheme colors) {
    switch (bid.status) {
      case 'pending':
        return const SizedBox.shrink();

      case 'selected':
        return Row(
          children: [
            Expanded(
              child: Button(
                text: 'Decline',
                buttonColor: colors.surface,
                textColor: colors.primary,
                borderColor: colors.primary,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: onSecondaryAction,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Button(
                text: 'Confirm',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: onPrimaryAction,
              ),
            ),
          ],
        );

      case 'confirmed':
        return Column(
          children: [
            Button(
              text: 'Apply for Guarantee',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              buttonWidth: double.infinity,
              buttonHeight: 44,
              elevation: 0,
              onPressed: onPrimaryAction,
            ),
            const SizedBox(height: 8),
            Button(
              text: 'Back Off',
              buttonColor: colors.surface,
              textColor: colors.secondary.withValues(alpha: 0.6),
              borderColor: colors.surfaceBright,
              borderRadius: 12,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              buttonWidth: double.infinity,
              buttonHeight: 40,
              elevation: 0,
              onPressed: onBackOffAction,
            ),
          ],
        );

      case 'guaranteePendingReview':
      case 'guaranteeIssued':
        return const SizedBox.shrink();

      case 'inProgress':
        return Column(
          children: [
            Button(
              text: 'Mark Work as Done',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              buttonWidth: double.infinity,
              buttonHeight: 44,
              elevation: 0,
              onPressed: onPrimaryAction,
            ),
            const SizedBox(height: 8),
            Button(
              text: 'Back Off',
              buttonColor: colors.surface,
              textColor: colors.secondary.withValues(alpha: 0.6),
              borderColor: colors.surfaceBright,
              borderRadius: 12,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              buttonWidth: double.infinity,
              buttonHeight: 40,
              elevation: 0,
              onPressed: onBackOffAction,
            ),
          ],
        );

      case 'workSubmitted':
        return const SizedBox.shrink();

      case 'guaranteeRejected':
        return Row(
          children: [
            Expanded(
              child: Button(
                text: 'Back Off',
                buttonColor: colors.surface,
                textColor: colors.primary,
                borderColor: colors.primary,
                borderRadius: 12,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: onBackOffAction,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Button(
                text: 'Apply for New Guarantee',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 44,
                elevation: 0,
                onPressed: onPrimaryAction,
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _StatusStyle {
  final String label;
  final Color bg;
  final Color text;
  const _StatusStyle({required this.label, required this.bg, required this.text});
}
