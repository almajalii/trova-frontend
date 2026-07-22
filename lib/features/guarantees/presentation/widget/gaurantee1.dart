// guarantee_step1_applicant_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_shared.dart';

class GuaranteeStep1ApplicantLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep1ApplicantLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFilled = model.legalCompanyName != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AppTitle(
          title: 'Applicant (Contractor) Information',
          size: 20,
          weight: FontWeight.w700,
          titleColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 6),
        AppText(
          text: 'Auto-filled from your Trova profile.',
          textSize: 13,
          textColor: colors.secondary.withValues(alpha: 0.6),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        if (isFilled)
          GuaranteeInfoCard(rows: [
            MapEntry('Contractor ID', model.contractorId ?? ''),
            MapEntry('Legal Company Name', model.legalCompanyName ?? ''),
            MapEntry('Registration Number (CR)', model.registrationNumber ?? ''),
            MapEntry('Tax / VAT Number', model.taxVatNumber ?? ''),
            MapEntry('Registered Address', model.registeredAddress ?? ''),
            MapEntry('Primary Contact', model.primaryContact ?? ''),
            MapEntry('Primary Email', model.primaryEmail ?? ''),
            MapEntry('Primary Phone', model.primaryPhone ?? ''),
          ])
        else
          AppText(
            text: 'Waiting on applicant details...',
            textSize: 13,
            textColor: colors.secondary.withValues(alpha: 0.6),
            textAlign: TextAlign.start,
          ),
        const SizedBox(height: 24),
        Button(
          text: 'Continue to Project Details',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 47,
          elevation: 0,
          onPressed: isFilled ? onContinue : null,
        ),
      ],
    );
  }
}
