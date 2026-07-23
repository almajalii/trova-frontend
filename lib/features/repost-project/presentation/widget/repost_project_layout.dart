import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trova/features/repost-project/logic/repost_project_model.dart';

class RepostProjectLayout extends StatelessWidget {
  static const _fieldFill = Color(0xFFFAFAFA);
  static const _fieldBorder = Color(0xFFD9D9DE);
  static const _noticeBg = Color(0xFFF7E5E7);
  static const _noticeText = Color(0xFFC8202E);
  static const _labelText = Color(0xFF333338);
  static const _valueText = Color(0xFF1A1A1A);

  final RepostProjectDraft draft;
  final bool isSubmitting;
  final VoidCallback onBack;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onSectorChanged;
  final ValueChanged<double> onContractValueChanged;
  final ValueChanged<int> onMinRequiredScoreChanged;
  final ValueChanged<ContractorClassification> onMinContractorClassificationChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<String> onTimelineChanged;
  final ValueChanged<List<String>> onMilestonesChanged;
  final ValueChanged<String> onGuaranteeTypeChanged;
  final ValueChanged<String> onPaymentTermsChanged;
  final ValueChanged<DateTime> onBidDeadlineChanged;
  final VoidCallback onSubmit;

  const RepostProjectLayout({
    super.key,
    required this.draft,
    required this.isSubmitting,
    required this.onBack,
    required this.onTitleChanged,
    required this.onSectorChanged,
    required this.onContractValueChanged,
    required this.onMinRequiredScoreChanged,
    required this.onMinContractorClassificationChanged,
    required this.onDescriptionChanged,
    required this.onLocationChanged,
    required this.onCurrencyChanged,
    required this.onTimelineChanged,
    required this.onMilestonesChanged,
    required this.onGuaranteeTypeChanged,
    required this.onPaymentTermsChanged,
    required this.onBidDeadlineChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BackRow(onBack: onBack),
            const SizedBox(height: 14),
            const Text(
              'Edit & Re-post Project',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _valueText),
            ),
            const SizedBox(height: 14),
            _NoticeBanner(message: draft.noticeMessage),
            const SizedBox(height: 14),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('Project Title'),
                    _TextInput(initialValue: draft.title, onChanged: onTitleChanged),
                    const SizedBox(height: 14),
                    _FieldLabel('Sector'),
                    _TextInput(initialValue: draft.sector, onChanged: onSectorChanged),
                    const SizedBox(height: 14),
                    _FieldLabel('Location'),
                    _TextInput(initialValue: draft.location, onChanged: onLocationChanged),
                    const SizedBox(height: 14),
                    _FieldLabel('Contract Value'),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _TextInput(
                            initialValue: _formatContractValue(draft.contractValueJod),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final parsed = double.tryParse(value.replaceAll(',', ''));
                              if (parsed != null) onContractValueChanged(parsed);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _TextInput(
                            initialValue: draft.currency,
                            onChanged: onCurrencyChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Timeline / Duration'),
                    _TextInput(initialValue: draft.timelineText, onChanged: onTimelineChanged),
                    const SizedBox(height: 14),
                    _FieldLabel('Bid Submission Deadline'),
                    _DatePickerField(
                      value: draft.bidSubmissionDeadline,
                      onChanged: onBidDeadlineChanged,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Minimum Required Score'),
                    _TextInput(
                      initialValue: '${draft.minRequiredScore}+',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final parsed = int.tryParse(value.replaceAll('+', '').trim());
                        if (parsed != null) onMinRequiredScoreChanged(parsed);
                      },
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Minimum Contractor Classification'),
                    _ClassificationDropdown(
                      value: draft.minContractorClassification,
                      onChanged: onMinContractorClassificationChanged,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Guarantee Type Required'),
                    _TextInput(
                      initialValue: draft.guaranteeTypeRequired,
                      onChanged: onGuaranteeTypeChanged,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Payment Terms'),
                    _TextInput(
                      initialValue: draft.paymentTerms,
                      onChanged: onPaymentTermsChanged,
                      maxLines: 2,
                      minLines: 1,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Milestones (one per line)'),
                    _TextInput(
                      initialValue: draft.milestones.join('\n'),
                      onChanged: (value) {
                        final lines = value
                            .split('\n')
                            .map((line) => line.trim())
                            .where((line) => line.isNotEmpty)
                            .toList();
                        onMilestonesChanged(lines);
                      },
                      maxLines: 6,
                      minLines: 3,
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel('Project Description'),
                    _TextInput(
                      initialValue: draft.description,
                      onChanged: onDescriptionChanged,
                      maxLines: 4,
                      minLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            _RepostButton(isSubmitting: isSubmitting, onPressed: onSubmit),
          ],
        ),
      ),
    );
  }

  static String _formatContractValue(double value) {
    final intValue = value.toInt();
    final s = intValue.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class _BackRow extends StatelessWidget {
  final VoidCallback onBack;

  const _BackRow({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: onBack,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.arrow_back, color: RepostProjectLayout._valueText, size: 22),
      ),
    );
  }
}

class _NoticeBanner extends StatelessWidget {
  final String message;

  const _NoticeBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: RepostProjectLayout._noticeBg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 15, color: RepostProjectLayout._noticeText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 12, height: 1.4, color: RepostProjectLayout._noticeText),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: RepostProjectLayout._labelText),
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  const _TextInput({
    required this.initialValue,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RepostProjectLayout._valueText),
      decoration: InputDecoration(
        filled: true,
        fillColor: RepostProjectLayout._fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: RepostProjectLayout._fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: RepostProjectLayout._fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class _ClassificationDropdown extends StatelessWidget {
  final ContractorClassification value;
  final ValueChanged<ContractorClassification> onChanged;

  const _ClassificationDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ContractorClassification>(
      initialValue: value,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: RepostProjectLayout._valueText),
      decoration: InputDecoration(
        filled: true,
        fillColor: RepostProjectLayout._fieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: RepostProjectLayout._fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: RepostProjectLayout._fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      items: ContractorClassification.values
          .map((c) => DropdownMenuItem(value: c, child: Text(c.displayLabel)))
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  const _DatePickerField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value.isAfter(DateTime.now()) ? value : DateTime.now().add(const Duration(days: 1)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: RepostProjectLayout._fieldFill,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: RepostProjectLayout._fieldBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd MMM yyyy').format(value),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: RepostProjectLayout._valueText,
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: RepostProjectLayout._labelText),
          ],
        ),
      ),
    );
  }
}

class _RepostButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _RepostButton({required this.isSubmitting, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: RepostProjectLayout._noticeText,
          disabledBackgroundColor: RepostProjectLayout._noticeText.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Text(
                'Re-post Project',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
      ),
    );
  }
}
