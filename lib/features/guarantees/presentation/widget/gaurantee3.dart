// guarantee_step3_details_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_shared.dart';

class GuaranteeStep3DetailsLayout extends StatefulWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep3DetailsLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  State<GuaranteeStep3DetailsLayout> createState() => _GuaranteeStep3DetailsLayoutState();
}

class _GuaranteeStep3DetailsLayoutState extends State<GuaranteeStep3DetailsLayout> {
  late final _amountController =
      TextEditingController(text: widget.model.guaranteedAmount?.toString() ?? '');
  late final _conditionsController =
      TextEditingController(text: widget.model.specialConditions ?? '');

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    widget.onChanged(isStart
        ? widget.model.copyWith(validityStart: picked)
        : widget.model.copyWith(validityExpiry: picked));
  }

  bool get _isValid =>
      widget.model.guaranteeType != null &&
      widget.model.guaranteedAmount != null &&
      widget.model.validityStart != null &&
      widget.model.validityExpiry != null;

  String _formatDate(DateTime? d) => d == null ? '' : d.toIso8601String().split('T').first;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AppTitle(
          title: 'Guarantee Request Details',
          size: 20,
          weight: FontWeight.w700,
          titleColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),

        const GuaranteeLabel('Type of Guarantee'),
        GuaranteeDropdownField<GuaranteeType>(
          value: widget.model.guaranteeType,
          hint: 'Select guarantee type',
          items: GuaranteeType.values,
          labelBuilder: _typeLabel,
          onChanged: (t) => widget.onChanged(widget.model.copyWith(guaranteeType: t)),
        ),
        const SizedBox(height: 18),

        const GuaranteeLabel('Guaranteed Amount'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: colors.onSurface, fontSize: 15),
                onChanged: (v) =>
                    widget.onChanged(widget.model.copyWith(guaranteedAmount: double.tryParse(v))),
                decoration: InputDecoration(
                  hintText: 'e.g. 48,000',
                  hintStyle: TextStyle(color: colors.surfaceBright, fontSize: 15, fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: colors.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.surfaceBright),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.surfaceBright),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: colors.surfaceBright),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppText(text: widget.model.currency, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface),
            ),
          ],
        ),
        const SizedBox(height: 18),

        const GuaranteeLabel('Validity Period'),
        Row(
          children: [
            Expanded(
              child: GuaranteePickerField(
                text: _formatDate(widget.model.validityStart),
                placeholder: 'Start Date',
                onTap: () => _pickDate(isStart: true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GuaranteePickerField(
                text: _formatDate(widget.model.validityExpiry),
                placeholder: 'Expiry Date',
                onTap: () => _pickDate(isStart: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        const GuaranteeLabel('Special Conditions (Optional)'),
        GuaranteeMultilineField(
          controller: _conditionsController,
          hintText: 'Any additional terms or conditions...',
          maxLines: 3,
          onChanged: (v) => widget.onChanged(widget.model.copyWith(specialConditions: v)),
        ),
        const SizedBox(height: 24),

        Button(
          text: 'Continue to Beneficiary Info',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 47,
          elevation: 0,
          onPressed: _isValid ? widget.onContinue : null,
        ),
      ],
    );
  }

  String _typeLabel(GuaranteeType t) {
    switch (t) {
      case GuaranteeType.performance:
        return 'Performance Guarantee';
      case GuaranteeType.bidBond:
        return 'Bid Bond Guarantee';
      case GuaranteeType.advancePayment:
        return 'Advance Payment Guarantee';
      case GuaranteeType.retention:
        return 'Retention Guarantee';
    }
  }
}
