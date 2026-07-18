import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/success_badge.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class AwardRequestGuaranteeLayout extends StatelessWidget {
  final String projectTitle;
  final String awardedCompanyName;
  final TextEditingController amountController;
  final GuaranteeType type;
  final ValueChanged<GuaranteeType> onTypeChanged;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const AwardRequestGuaranteeLayout({
    super.key,
    required this.projectTitle,
    required this.awardedCompanyName,
    required this.amountController,
    required this.type,
    required this.onTypeChanged,
    required this.isLoading,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back, color: colors.onSurface), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  const SuccessBadge(),
                  const SizedBox(height: 16),
                  AppTitle(title: 'Project Awarded', size: 22, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
                  const SizedBox(height: 10),
                  AppText(
                    text: '$awardedCompanyName has been awarded $projectTitle. Request a bank guarantee to finalize.',
                    textSize: 14,
                    textColor: colors.onSurfaceVariant,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  _Label('Guarantee Amount (JOD)'),
                  InputField(controller: amountController, hintText: '', keyboardType: TextInputType.text),
                  const SizedBox(height: 18),
                  _Label('Guarantee Type'),
                  _TypeDropdown(value: type, onChanged: onTypeChanged),
                ],
              ),
            ),
            Button(
              text: isLoading ? 'Requesting...' : 'Request Bank Guarantee',
              textColor: Colors.white,
              borderRadius: 10,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: isLoading ? null : onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppText(text: text, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  final GuaranteeType value;
  final ValueChanged<GuaranteeType> onChanged;
  const _TypeDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: colors.surface, border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<GuaranteeType>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: colors.onSurface),
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.onSurface),
          items: GuaranteeType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
