import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';

/// Shows the "Sign in with Sanad" consent bottom sheet. Resolves to `true`
/// if the user tapped Continue, `false`/`null` if they cancelled/dismissed.
Future<bool?> showSanadModal(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const _SanadModalContent(),
  );
}

class _SanadModalContent extends StatelessWidget {
  const _SanadModalContent();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colors.primary,
                child: const Text('S', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context, false),
                icon: Icon(Icons.close, color: colors.onSurfaceVariant),
              ),
            ],
          ),

          const SizedBox(height: 16),

          AppTitle(
            title: 'Sign in with Sanad',
            size: 20,
            weight: FontWeight.bold,
            titleColor: colors.onSurface,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 12),

          AppText(
            text: "You'll be securely redirected to Sanad to log in. Once verified, Trova will receive your name and National ID automatically.",
            textSize: 14,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Trova will receive:',
                  textSize: 13,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                _bulletRow(colors, 'Full name'),
                const SizedBox(height: 8),
                _bulletRow(colors, 'National ID (الرقم الوطني)'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Button(
            text: 'Continue to Sanad',
            textColor: colors.onPrimary,
            borderRadius: 12,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            elevation: 0,
            buttonWidth: double.infinity,
            buttonHeight: 48,
            onPressed: () => Navigator.pop(context, true),
          ),

          const SizedBox(height: 12),

          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context, false),
              child: AppText(
                text: 'Cancel',
                textSize: 14,
                fontWeight: FontWeight.w600,
                textColor: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletRow(ColorScheme colors, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 8),
          child: CircleAvatar(radius: 2, backgroundColor: colors.onSurfaceVariant),
        ),
        Expanded(
          child: AppText(
            text: text,
            textSize: 13,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
