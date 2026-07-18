import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

/// Bottom-sheet consent modal for Open Finance authorization. Mirrors the
/// Figma "Bank Consent Modal" — shown from ConnectBankAccountScreen.
class BankConsentModal extends StatelessWidget {
  final BankOption bank;
  final bool isAuthorizing;
  final VoidCallback onAuthorize;
  final VoidCallback onCancel;

  const BankConsentModal({
    super.key,
    required this.bank,
    required this.isAuthorizing,
    required this.onAuthorize,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: colors.primary, borderRadius: BorderRadius.circular(10)),
                  child: Text(bank.code, style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white)),
                ),
                IconButton(onPressed: isAuthorizing ? null : onCancel, icon: Icon(Icons.close, color: colors.onSurfaceVariant)),
              ],
            ),
            AppText(text: 'Connect with ${bank.name}', textSize: 19, fontWeight: FontWeight.w700, textColor: colors.onSurface, textAlign: TextAlign.start),
            const SizedBox(height: 8),
            AppText(text: "You'll be securely redirected to ${bank.name} to log in via Open Finance.", textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: 'Trova will receive:', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
                  const SizedBox(height: 8),
                  const _Bullet('Account balances & assets'),
                  const SizedBox(height: 6),
                  const _Bullet('Existing debt & repayment history'),
                  const SizedBox(height: 6),
                  const _Bullet('Transaction history'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Button(
              text: isAuthorizing ? 'Authorizing...' : 'Authorize Access',
              textColor: Colors.white,
              borderRadius: 9,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: 48,
              onPressed: isAuthorizing ? null : onAuthorize,
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: isAuthorizing ? null : onCancel,
                child: AppText(text: 'Cancel', textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 8),
          child: Container(width: 4, height: 4, decoration: BoxDecoration(color: colors.onSurfaceVariant, shape: BoxShape.circle)),
        ),
        Expanded(child: AppText(text: text, textSize: 12, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start)),
      ],
    );
  }
}
