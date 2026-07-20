import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/success_badge.dart';

/// Shared shape for the three simple confirmation screens in this feature
/// (Project Awarded, Guarantee Verified, Guarantee Rejected) — a centered
/// badge, title, message, and a single full-width button. Only the badge
/// tone and copy differ between them.
class ConfirmationLayout extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onButtonPressed;
  final Widget? badge; // ← this line needs to be there

  const ConfirmationLayout({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal, vertical: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            badge ?? (isSuccess ? const SuccessBadge() : const _FailureBadge()),
            const SizedBox(height: 20),
            AppText(
              text: title,
              textSize: 20,
              fontWeight: FontWeight.w700,
              textColor: colors.onSurface,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            AppText(text: message, textSize: 14, textColor: colors.onSurfaceVariant, textAlign: TextAlign.center),
            const Spacer(flex: 3),
            Button(
              text: buttonLabel,
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              buttonColor: colors.primary,
              onPressed: onButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}

/// Red counterpart to SuccessBadge — a danger-toned circle with an X,
/// used for the Guarantee Rejected confirmation.
class _FailureBadge extends StatelessWidget {
  const _FailureBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(color: AppColors.dangerBg, shape: BoxShape.circle),
      child: const Icon(Icons.close, color: AppColors.danger, size: 30),
    );
  }
}
