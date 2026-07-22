// guarantee_step6_declarations_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_shared.dart';

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
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AppTitle(
          title: 'Declarations & Submission',
          size: 20,
          weight: FontWeight.w700,
          titleColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        _CheckRow(
          text: 'I confirm that all information provided in this application is accurate and complete.',
          value: model.confirmAccurate,
          onChanged: (v) => onChanged(model.copyWith(confirmAccurate: v)),
        ),
        const SizedBox(height: 10),
        _CheckRow(
          text: 'I agree to indemnify the bank for this guarantee under its standard terms.',
          value: model.agreeIndemnify,
          onChanged: (v) => onChanged(model.copyWith(agreeIndemnify: v)),
        ),
        const SizedBox(height: 10),
        _CheckRow(
          text: "I accept Trova's and the issuing bank's Terms & Conditions.",
          value: model.acceptTerms,
          onChanged: (v) => onChanged(model.copyWith(acceptTerms: v)),
        ),
        const SizedBox(height: 20),
        const GuaranteeLabel('Digital Signature'),
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
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(color: colors.surfaceBright),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: AppText(
              text: model.signatureName == null
                  ? 'Tap to sign'
                  : 'Tap to sign — ${model.signatureName}',
              textSize: 14,
              fontWeight: model.signatureName == null ? FontWeight.w500 : FontWeight.w600,
              textColor: model.signatureName == null ? colors.surfaceBright : colors.onSurface,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Button(
          text: isSubmitting ? 'Submitting...' : 'Submit Guarantee Application',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 47,
          elevation: 0,
          onPressed: _isValid && !isSubmitting ? onSubmit : null,
        ),
      ],
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
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: GuaranteeCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: value,
              activeColor: colors.primary,
              onChanged: (v) => onChanged(v ?? false),
            ),
            Expanded(
              child: AppText(text: text, textSize: 13, textColor: colors.onSurface, textAlign: TextAlign.start),
            ),
          ],
        ),
      ),
    );
  }
}
