import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';

class CompanyDetailsLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController companyNameController;
  final TextEditingController sectorController;
  final TextEditingController registrationNumberController;
  final TextEditingController yearsInOperationController;
  final TextEditingController teamSizeController;
  final TextEditingController annualRevenueController;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const CompanyDetailsLayout({
    super.key,
    required this.formKey,
    required this.companyNameController,
    required this.sectorController,
    required this.registrationNumberController,
    required this.yearsInOperationController,
    required this.teamSizeController,
    required this.annualRevenueController,
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back, color: colors.onSurface), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    AppTitle(title: 'Tell Us About Your Company', size: 22, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
                    const SizedBox(height: 8),
                    AppText(
                      text: 'This determines your company classification and feeds into your capability score.',
                      textSize: 13,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 18),
                    _Label('Company Name'),
                    InputField(controller: companyNameController, hintText: 'e.g. Al-Fahad Contracting', validator: _required),
                    const SizedBox(height: 16),
                    _Label('Sector'),
                    InputField(controller: sectorController, hintText: 'e.g. Construction & Engineering', validator: _required),
                    const SizedBox(height: 16),
                    _Label('Registration Number'),
                    InputField(controller: registrationNumberController, hintText: 'Company registration ID', validator: _required),
                    const SizedBox(height: 16),
                    _Label('Years in Operation'),
                    InputField(controller: yearsInOperationController, hintText: 'e.g. 11', keyboardType: TextInputType.number, validator: _required),
                    const SizedBox(height: 16),
                    _Label('Team Size'),
                    InputField(controller: teamSizeController, hintText: 'Number of employees', keyboardType: TextInputType.number, validator: _required),
                    const SizedBox(height: 16),
                    _Label('Annual Revenue (JOD)'),
                    InputField(controller: annualRevenueController, hintText: 'Approximate last fiscal year', keyboardType: TextInputType.number, validator: _required),
                    const SizedBox(height: 16),
                    AppText(
                      text: "Your classification (e.g. Class A – Large Enterprise) is calculated from this, and determines which projects you're eligible to bid on.",
                      textSize: 11,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Button(
                text: isLoading ? 'Saving...' : 'Continue to Connect Bank',
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
      ),
    );
  }

  static String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
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
