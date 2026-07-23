import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/contractor_tap_target.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String formatGuaranteeDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

String formatGuaranteeAmount(double jod) {
  final digits = jod.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return 'JOD $buffer';
}

class ReviewGuaranteeLayout extends StatelessWidget {
  final OwnerGuarantee guarantee;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  /// Called with the owner's optional note once they confirm the reject
  /// dialog — null if they left it blank.
  final ValueChanged<String?> onReject;

  const ReviewGuaranteeLayout({
    super.key,
    required this.guarantee,
    required this.isSubmitting,
    required this.onBack,
    required this.onConfirm,
    required this.onReject,
  });

  /// Only ISSUED (bank has decided) is actionable. PENDING_REVIEW — and any
  /// other status that unexpectedly lands here — renders read-only: there's
  /// nothing for the owner to do until the bank issues it.
  bool get _isIssued => guarantee.status == OwnerGuaranteeStatus.issued;

  Future<void> _showRejectDialog(BuildContext context) async {
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject Guarantee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Let ${guarantee.contractorName} know why you're rejecting it (optional)."),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Reason', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Reject', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null) return; // dialog cancelled
    onReject(reason.isEmpty ? null : reason);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
            text: 'Review Guarantee',
            textSize: 20,
            fontWeight: FontWeight.w700,
            textColor: colors.onSurface,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          ContractorTapTarget(
            contractor: guarantee.awardedBidder,
            child: AppText(
              text: _isIssued
                  ? '${guarantee.contractorName} submitted a bank guarantee for ${guarantee.projectTitle}. Review the details before confirming.'
                  : '${guarantee.contractorName} submitted a bank guarantee for ${guarantee.projectTitle}. ${guarantee.issuingBank} is reviewing it — we\'ll notify you once a decision is made.',
              textSize: 13,
              textColor: guarantee.awardedBidder != null ? colors.primary : colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colors.surfaceBright),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isIssued
                    ? StatusPill(
                        text: '✓ Issued by ${guarantee.issuingBank}',
                        background: AppColors.successBg,
                        foreground: AppColors.success,
                        fontSize: 12,
                      )
                    : const StatusPill(
                        text: 'Pending Bank Review',
                        background: AppColors.warningBg,
                        foreground: AppColors.warning,
                        fontSize: 12,
                      ),
                const SizedBox(height: 14),
                _Row(label: 'Guarantee ID', value: guarantee.guaranteeId, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Bank', value: guarantee.issuingBank, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Amount', value: formatGuaranteeAmount(guarantee.amountJod), colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Type', value: guarantee.type, colors: colors),
                if (guarantee.validUntil != null) ...[
                  const SizedBox(height: 10),
                  _Row(label: 'Valid Until', value: formatGuaranteeDate(guarantee.validUntil!), colors: colors),
                ],
              ],
            ),
          ),
          if (_isIssued) ...[
            const SizedBox(height: 24),
            Button(
              text: 'Confirm Guarantee',
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              buttonColor: colors.primary,
              onPressed: isSubmitting ? null : onConfirm,
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: isSubmitting ? null : () => _showRejectDialog(context),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, context.buttonSizeH),
                side: const BorderSide(color: AppColors.danger),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: AppText(
                text: 'Reject Guarantee',
                textSize: 16,
                fontWeight: FontWeight.w600,
                textColor: AppColors.danger,
                textAlign: TextAlign.center,
              ),
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
