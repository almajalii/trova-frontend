import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';

class IdentityConfirmLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final IdentityInfo info;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  const IdentityConfirmLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.info,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.vertical),

            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: colors.onSurface),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),

            const SizedBox(height: 16),

            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
              child: Icon(Icons.check, color: colors.primary, size: 32),
            ),

            const SizedBox(height: 20),

            AppTitle(
              title: title,
              size: 22,
              weight: FontWeight.bold,
              titleColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 8),

            AppText(text: subtitle, textSize: 14, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),

            const SizedBox(height: 24),

            AppText(
              text: 'Full Name',
              textSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            _ReadOnlyField(value: info.fullName),

            const SizedBox(height: 20),

            AppText(
              text: 'National ID (الرقم الوطني)',
              textSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            _ReadOnlyField(value: info.nationalId),

            const Spacer(),

            Button(
              text: 'Confirm & Continue',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: onConfirm,
            ),

            SizedBox(height: context.vertical),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String value;
  const _ReadOnlyField({required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBright, width: 1),
      ),
      child: AppText(text: value, textSize: 15, textColor: colors.onSurface, textAlign: TextAlign.start),
    );
  }
}
