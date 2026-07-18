import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/core/success_badge.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeVerifiedLayout extends StatelessWidget {
  final Guarantee guarantee;
  final VoidCallback onBack;
  final VoidCallback onDone;

  const GuaranteeVerifiedLayout({super.key, required this.guarantee, required this.onBack, required this.onDone});

  String _jod(double v) => 'JOD ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back, color: colors.onSurface), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  const SuccessBadge(),
                  const SizedBox(height: 16),
                  AppTitle(title: 'Guarantee Verified', size: 22, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
                  const SizedBox(height: 10),
                  AppText(
                    text: 'The bank guarantee has been digitally issued and instantly verified.',
                    textSize: 14,
                    textColor: colors.onSurfaceVariant,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Row('Guarantee ID', guarantee.id),
                        const SizedBox(height: 12),
                        _Row('Amount', _jod(guarantee.amountJod)),
                        const SizedBox(height: 12),
                        _Row('Type', guarantee.type.label),
                        const SizedBox(height: 12),
                        _Row('Issuing Bank', guarantee.issuingBank),
                        const SizedBox(height: 12),
                        _Row('Valid Until', DateFormat('MMMM d, yyyy').format(guarantee.validUntil)),
                        const SizedBox(height: 12),
                        const StatusPill(text: '● Active & Verified', background: AppColors.successBg, foreground: AppColors.success),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Button(
              text: 'Back to Dashboard',
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: onDone,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(text: label, textSize: 13, textColor: colors.onSurfaceVariant),
        AppText(text: value, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface),
      ],
    );
  }
}
