// guarantee_step6_declarations_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeStep6DeclarationsLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  const GuaranteeStep6DeclarationsLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onSubmit,
    this.isSubmitting = false,
  });

  bool get _isValid =>
      model.confirmAccurate &&
      model.agreeIndemnify &&
      model.acceptTerms &&
      model.signatureName != null &&
      model.signatureName!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Declarations & Submission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _CheckRow(
            text: 'I confirm that all information provided in this application is accurate and complete.',
            value: model.confirmAccurate,
            onChanged: (v) => onChanged(model.copyWith(confirmAccurate: v)),
          ),
          _CheckRow(
            text: 'I agree to indemnify the bank for this guarantee under its standard terms.',
            value: model.agreeIndemnify,
            onChanged: (v) => onChanged(model.copyWith(agreeIndemnify: v)),
          ),
          _CheckRow(
            text: "I accept Trova's and the issuing bank's Terms & Conditions.",
            value: model.acceptTerms,
            onChanged: (v) => onChanged(model.copyWith(acceptTerms: v)),
          ),
          const SizedBox(height: 16),
          const Text('Digital Signature'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              // TODO: replace with a proper signature capture flow if needed;
              // for now this just captures a typed name as the signature
              final name = await showDialog<String>(
                context: context,
                builder: (ctx) {
                  final controller = TextEditingController(text: model.signatureName);
                  return AlertDialog(
                    title: const Text('Sign your name'),
                    content: TextField(controller: controller, autofocus: true),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(controller.text),
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
              if (name != null && name.isNotEmpty) {
                onChanged(model.copyWith(signatureName: name));
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                model.signatureName == null
                    ? 'Tap to sign'
                    : 'Tap to sign — ${model.signatureName}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid && !isSubmitting ? onSubmit : null,
              child: isSubmitting
                  ? const SizedBox(
                      height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Submit Guarantee Application'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckRow({required this.text, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.surfaceBright),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Checkbox(value: value, onChanged: (v) => onChanged(v ?? false)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}