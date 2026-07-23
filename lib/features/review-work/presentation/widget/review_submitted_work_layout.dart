import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/contractor_tap_target.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/review-work/logic/submitted_work_model.dart';

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

String _formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

String _formatValue(double jod) {
  final digits = jod.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return 'JOD $buffer';
}

class ReviewSubmittedWorkLayout extends StatelessWidget {
  final SubmittedWork work;
  final bool isSubmitting;
  final VoidCallback onBack;
  final VoidCallback onFlagIssue;
  final VoidCallback onConfirmComplete;

  const ReviewSubmittedWorkLayout({
    super.key,
    required this.work,
    required this.isSubmitting,
    required this.onBack,
    required this.onFlagIssue,
    required this.onConfirmComplete,
  });

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
          StatusPill(
            text: 'Pending Your Review',
            background: AppColors.warningBg,
            foreground: AppColors.warning,
            fontSize: 11,
          ),
          const SizedBox(height: 12),
          AppText(
            text: work.projectTitle,
            textSize: 22,
            fontWeight: FontWeight.w700,
            textColor: colors.onSurface,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          ContractorTapTarget(
            contractor: work.awardedBidder,
            child: AppText(
              text: '${work.contractorName} has marked this project as complete. Review before confirming.',
              textSize: 13,
              textColor: work.awardedBidder != null ? colors.primary : colors.onSurfaceVariant,
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
              children: [
                _Row(label: 'Sector', value: work.sector, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Location', value: work.location, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Contract Value', value: _formatValue(work.contractValueJod), colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Timeline', value: work.timelineText, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Milestones', value: work.milestones, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Guarantee Type Required', value: work.guaranteeTypeRequired, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Payment Terms', value: work.paymentTerms, colors: colors),
                const SizedBox(height: 10),
                _Row(label: 'Contractor', value: work.contractorName, colors: colors, contractor: work.awardedBidder),
                const SizedBox(height: 10),
                _Row(label: 'Submitted', value: _formatDate(work.submittedDate), colors: colors),
                if (work.guaranteeRowText != null) ...[
                  const SizedBox(height: 10),
                  _Row(label: 'Guarantee', value: work.guaranteeRowText!, colors: colors),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isSubmitting ? null : onFlagIssue,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, context.buttonSizeH),
                    side: BorderSide(color: colors.surfaceBright),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: AppText(
                    text: 'Flag an Issue',
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
                  text: 'Confirm Complete',
                  textColor: Colors.white,
                  borderRadius: 10,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  elevation: 0,
                  buttonWidth: double.infinity,
                  buttonHeight: context.buttonSizeH,
                  buttonColor: colors.primary,
                  onPressed: isSubmitting ? null : onConfirmComplete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colors;
  final Bidder? contractor;
  const _Row({required this.label, required this.value, required this.colors, this.contractor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: label, textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
        const SizedBox(width: 12),
        Expanded(
          child: ContractorTapTarget(
            contractor: contractor,
            child: AppText(
              text: value,
              textSize: 13,
              fontWeight: FontWeight.w600,
              textColor: contractor != null ? colors.primary : colors.onSurface,
              textAlign: TextAlign.end,
            ),
          ),
        ),
      ],
    );
  }
}
