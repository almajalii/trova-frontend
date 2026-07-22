// guarantee_step2_project_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_shared.dart';

class GuaranteeStep2ProjectLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep2ProjectLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isFilled = model.projectName != null;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AppTitle(
          title: 'Project Details',
          size: 20,
          weight: FontWeight.w700,
          titleColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        const GuaranteeLabel('Project ID'),
        GuaranteeReadOnlyField(
          text: model.projectId ?? '',
          placeholder: 'TRV-PRJ-xxxxx (auto-linked to this bid)',
        ),
        const SizedBox(height: 20),
        if (isFilled)
          GuaranteeInfoCard(rows: [
            MapEntry('Project Name', model.projectName ?? ''),
            MapEntry('Location', model.location ?? ''),
            MapEntry('Contract Value', model.contractValue != null ? 'JOD ${model.contractValue}' : ''),
            MapEntry('Description', model.description ?? ''),
            MapEntry('Contract Duration', model.contractDuration ?? ''),
          ])
        else
          AppText(
            text: 'Waiting on project link...',
            textSize: 13,
            textColor: colors.secondary.withValues(alpha: 0.6),
            textAlign: TextAlign.start,
          ),
        const SizedBox(height: 24),
        Button(
          text: 'Continue to Guarantee Details',
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
