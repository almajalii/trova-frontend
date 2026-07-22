// guarantee_step3_details_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Guarantee Request Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Type of Guarantee'),
          const SizedBox(height: 8),
          DropdownButtonFormField<GuaranteeType>(
            value: widget.model.guaranteeType,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: GuaranteeType.values.map((t) {
              return DropdownMenuItem(value: t, child: Text(_typeLabel(t)));
            }).toList(),
            onChanged: (t) => widget.onChanged(widget.model.copyWith(guaranteeType: t)),
          ),
          const SizedBox(height: 16),
          const Text('Guaranteed Amount'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (v) => widget.onChanged(
                      widget.model.copyWith(guaranteedAmount: double.tryParse(v))),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.surfaceBright),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(widget.model.currency),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Validity Period'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(isStart: true),
                  child: Text(widget.model.validityStart == null
                      ? 'Start Date'
                      : widget.model.validityStart!.toIso8601String().split('T').first),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDate(isStart: false),
                  child: Text(widget.model.validityExpiry == null
                      ? 'Expiry Date'
                      : widget.model.validityExpiry!.toIso8601String().split('T').first),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Special Conditions (Optional)'),
          const SizedBox(height: 8),
          TextField(
            controller: _conditionsController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Any additional terms or conditions...',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => widget.onChanged(widget.model.copyWith(specialConditions: v)),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? widget.onContinue : null,
              child: const Text('Continue to Beneficiary Info'),
            ),
          ),
        ],
      ),
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