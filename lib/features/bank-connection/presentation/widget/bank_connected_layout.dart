import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/success_badge.dart';

class BankConnectedLayout extends StatelessWidget {
  final String bankName;
  final VoidCallback onGoToDashboard;

  const BankConnectedLayout({super.key, required this.bankName, required this.onGoToDashboard});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal * 0.9, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            const SuccessBadge(size: 88, iconSize: 40),
            const SizedBox(height: 28),
            AppTitle(title: 'Bank Connected', size: 24, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            AppText(
              text: '$bankName was linked successfully. We\'re calculating your capability score now.',
              textSize: 14,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 5),
            Button(
              text: 'Continue',
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: onGoToDashboard,
            ),
          ],
        ),
      ),
    );
  }
}
