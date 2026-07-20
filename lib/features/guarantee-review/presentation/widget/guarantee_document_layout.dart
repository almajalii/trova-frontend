import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';
import 'package:trova/features/guarantee-review/presentation/widget/review_guarantee_layout.dart'
    show formatGuaranteeAmount, formatGuaranteeDate;

class GuaranteeDocumentLayout extends StatelessWidget {
  final OwnerGuarantee guarantee;
  final VoidCallback onBack;
  final VoidCallback? onReverify;
  final VoidCallback? onDownloadPdf;

  const GuaranteeDocumentLayout({
    super.key,
    required this.guarantee,
    required this.onBack,
    this.onReverify,
    this.onDownloadPdf,
  });

  bool get _isClaimed => guarantee.status == OwnerGuaranteeStatus.claimed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tone = _isClaimed ? AppColors.danger : AppColors.success;
    final toneBg = _isClaimed ? AppColors.dangerBg : AppColors.successBg;
    final statusText = _isClaimed
        ? 'Claimed — Contract Not Fulfilled'
        : 'Active & Verified by ${guarantee.issuingBank}';

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 4, bottom: 32),
        children: [
          GestureDetector(
            onTap: onBack,
            child: Icon(Icons.arrow_back, color: colors.onSurface, size: 22),
          ),
          const SizedBox(height: 20),
          AppText(
            text: 'Guarantee Document',
            textSize: 20,
            fontWeight: FontWeight.w700,
            textColor: colors.onSurface,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colors.surfaceBright),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: toneBg, shape: BoxShape.circle),
                      child: AppText(
                        text: guarantee.bankInitials,
                        textSize: 14,
                        fontWeight: FontWeight.w700,
                        textColor: tone,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        text: guarantee.issuingBank,
                        textSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.onSurface,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                AppText(
                  text: formatGuaranteeAmount(guarantee.amountJod),
                  textSize: 26,
                  fontWeight: FontWeight.w700,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 4),
                AppText(
                  text: 'Guaranteed Amount',
                  textSize: 12,
                  textColor: colors.onSurfaceVariant,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16),
                Divider(color: colors.surfaceBright, height: 1),
                const SizedBox(height: 16),
                _Row(label: 'Guarantee ID', value: guarantee.guaranteeId, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Type', value: guarantee.type, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Beneficiary', value: guarantee.beneficiary, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Principal', value: guarantee.contractorName, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Project', value: guarantee.projectTitle, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Project ID', value: guarantee.projectId, colors: colors),
                if (guarantee.issueDate != null) ...[
                  const SizedBox(height: 10),
                  _Row(label: 'Issue Date', value: formatGuaranteeDate(guarantee.issueDate!), colors: colors),
                ],
                if (!_isClaimed && guarantee.validUntil != null) ...[
                  const SizedBox(height: 10),
                  _Row(label: 'Valid Until', value: formatGuaranteeDate(guarantee.validUntil!), colors: colors),
                ],
                if (_isClaimed && guarantee.claimDate != null) ...[
                  const SizedBox(height: 10),
                  _Row(label: 'Claim Date', value: formatGuaranteeDate(guarantee.claimDate!), colors: colors),
                ],
                const SizedBox(height: 14),
                StatusPill(text: statusText, background: toneBg, foreground: tone, fontSize: 12),
              ],
            ),
          ),
          if (!_isClaimed) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReverify,
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, context.buttonSizeH),
                      side: BorderSide(color: colors.surfaceBright),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: AppText(
                      text: 'Re-verify with Bank',
                      textSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: colors.onSurface,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    text: 'Download PDF',
                    textColor: Colors.white,
                    borderRadius: 10,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    elevation: 0,
                    buttonWidth: double.infinity,
                    buttonHeight: context.buttonSizeH,
                    buttonColor: colors.primary,
                    onPressed: onDownloadPdf,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colors;
  const _Row({required this.label, required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: label, textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
        const SizedBox(width: 12),
        Expanded(
          child: AppText(
            text: value,
            textSize: 13,
            fontWeight: FontWeight.w600,
            textColor: colors.onSurface,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
