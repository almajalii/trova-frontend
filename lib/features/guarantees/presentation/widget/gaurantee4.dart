// guarantee_step4_beneficiary_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_shared.dart';

class GuaranteeStep4BeneficiaryLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep4BeneficiaryLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AppTitle(
          title: 'Beneficiary (Project Owner) Information',
          size: 20,
          weight: FontWeight.w700,
          titleColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 6),
        AppText(
          text: "Auto-filled from the Project ID. Edit if this project has multiple owners.",
          textSize: 13,
          textColor: colors.secondary.withValues(alpha: 0.6),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        GuaranteeInfoCard(rows: [
          MapEntry('Beneficiary ID (Optional)', model.beneficiaryId ?? ''),
          MapEntry('Company Name', model.beneficiaryCompanyName ?? ''),
          MapEntry('Registered Address', model.beneficiaryAddress ?? ''),
          MapEntry('Contact Person', model.beneficiaryContact ?? ''),
          MapEntry('Email', model.beneficiaryEmail ?? ''),
          MapEntry('Phone (Optional)', model.beneficiaryPhone ?? ''),
        ]),
        const SizedBox(height: 8),
        Button(
          text: 'Edit Beneficiary Details',
          isText: true,
          textColor: colors.primary,
          borderRadius: 0,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          buttonWidth: 0,
          buttonHeight: 0,
          elevation: 0,
          onPressed: () {
            // TODO: open an edit sheet/dialog to modify beneficiary fields
          },
        ),
        const SizedBox(height: 16),
        Button(
          text: 'Continue to Documents',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 47,
          elevation: 0,
          onPressed: onContinue,
        ),
      ],
    );
  }
}
