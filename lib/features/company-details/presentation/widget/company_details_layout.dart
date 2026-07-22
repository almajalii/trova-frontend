import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';

class CompanyDetailsLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  // Company Legal Info
  final TextEditingController legalCompanyNameController;
  final TextEditingController tradingNameController;
  final TextEditingController registrationNumberController;
  final TextEditingController taxVatNumberController;
  final TextEditingController legalStructureController;
  final TextEditingController yearOfEstablishmentController;
  final TextEditingController registeredAddressController;
  final TextEditingController countryOfRegistrationController;

  // Contact Information
  final TextEditingController primaryContactNameController;
  final TextEditingController positionTitleController;
  final TextEditingController primaryEmailController;
  final TextEditingController primaryPhoneNumberController;

  // Business Qualifications
  final TextEditingController businessLicenseNumberController;
  final TextEditingController contractorClassificationGradeController;
  final List<String> selectedSectors;
  final ValueChanged<List<String>> onSectorsChanged;
  final String? sectorsErrorText;
  final TextEditingController yearsOfExperienceController;
  final TextEditingController teamSizeController;
  final TextEditingController annualRevenueController;

  // Banking Basics
  final TextEditingController primaryBankNameController;
  final TextEditingController ibanNumberController;
  final TextEditingController swiftBicCodeController;
  final TextEditingController bankBranchNameCityController;

  final VoidCallback onPickBank;

  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const CompanyDetailsLayout({
    super.key,
    required this.formKey,
    required this.legalCompanyNameController,
    required this.tradingNameController,
    required this.registrationNumberController,
    required this.taxVatNumberController,
    required this.legalStructureController,
    required this.yearOfEstablishmentController,
    required this.registeredAddressController,
    required this.countryOfRegistrationController,
    required this.primaryContactNameController,
    required this.positionTitleController,
    required this.primaryEmailController,
    required this.primaryPhoneNumberController,
    required this.businessLicenseNumberController,
    required this.contractorClassificationGradeController,
    required this.selectedSectors,
    required this.onSectorsChanged,
    this.sectorsErrorText,
    required this.yearsOfExperienceController,
    required this.teamSizeController,
    required this.annualRevenueController,
    required this.primaryBankNameController,
    required this.onPickBank,
    required this.ibanNumberController,
    required this.swiftBicCodeController,
    required this.bankBranchNameCityController,
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
              IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back, color: colors.onSurface),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              Expanded(
                // SingleChildScrollView + Column (not ListView) — ListView
                // only mounts children near the viewport, so any FormField
                // scrolled out of view at submit time is invisible to
                // Form.validate() and its "required" check silently gets
                // skipped, letting blank fields through to the backend.
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    AppTitle(
                      title: 'Tell Us About Your Company',
                      size: 22,
                      weight: FontWeight.w700,
                      titleColor: colors.onSurface,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text:
                          'This information is used for your classification, capability score, and any bank guarantees you apply for.',
                      textSize: 13,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 18),

                    // ── Company Legal Info ──────────────────────────
                    _SectionHeader('COMPANY LEGAL INFO'),
                    _Label('Legal Company Name'),
                    InputField(
                      controller: legalCompanyNameController,
                      hintText: 'e.g. Al-Fahad Contracting LLC',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Trading Name (DBA)'),
                    InputField(controller: tradingNameController, hintText: 'e.g. Al-Fahad Contracting'),
                    const SizedBox(height: 16),
                    _Label('Company Registration Number (CR)'),
                    InputField(
                      controller: registrationNumberController,
                      hintText: 'e.g. JO-CR-118820',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Tax / VAT Number'),
                    InputField(
                      controller: taxVatNumberController,
                      hintText: 'e.g. JO-TAX-994512',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Company Legal Structure'),
                    InputField(
                      controller: legalStructureController,
                      hintText: 'e.g. Limited Liability Company (LLC)',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Year of Establishment'),
                    InputField(
                      controller: yearOfEstablishmentController,
                      hintText: 'e.g. 2015',
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Registered Address'),
                    InputField(
                      controller: registeredAddressController,
                      hintText: 'e.g. Wadi Saqra, Amman, Jordan',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Country of Registration'),
                    InputField(
                      controller: countryOfRegistrationController,
                      hintText: 'e.g. Jordan',
                      validator: _required,
                    ),
                    const SizedBox(height: 20),

                    // ── Contact Information ─────────────────────────
                    _SectionHeader('CONTACT INFORMATION'),
                    _Label('Primary Contact Person Name'),
                    InputField(
                      controller: primaryContactNameController,
                      hintText: 'e.g. Ahmad Khalil',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Position / Title'),
                    InputField(
                      controller: positionTitleController,
                      hintText: 'e.g. Operations Director',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Primary Email'),
                    InputField(
                      controller: primaryEmailController,
                      hintText: 'e.g. ahmad.khalil@company.jo',
                      keyboardType: TextInputType.emailAddress,
                      validator: _email,
                    ),
                    const SizedBox(height: 16),
                    _Label('Primary Phone Number'),
                    InputField(
                      controller: primaryPhoneNumberController,
                      hintText: 'e.g. +962 79 123 4567',
                      keyboardType: TextInputType.phone,
                      validator: _required,
                    ),
                    const SizedBox(height: 20),

                    // ── Business Qualifications ─────────────────────
                    _SectionHeader('BUSINESS QUALIFICATIONS'),
                    _Label('Business / Commercial License Number'),
                    InputField(
                      controller: businessLicenseNumberController,
                      hintText: 'e.g. JO-LIC-55291',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Contractor Classification / Grade'),
                    InputField(
                      controller: contractorClassificationGradeController,
                      hintText: 'e.g. Grade A (Ministry of Public Works)',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Main Areas of Expertise'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: kAllowedSectors.map((sector) {
                        final isSelected = selectedSectors.contains(sector);
                        return FilterChip(
                          label: Text(sector),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: colors.primary.withValues(alpha: 0.15),
                          backgroundColor: colors.surface,
                          side: BorderSide(color: isSelected ? colors.primary : colors.surfaceBright, width: 1),
                          labelStyle: TextStyle(
                            color: isSelected ? colors.primary : colors.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                          onSelected: (selected) {
                            final updated = List<String>.from(selectedSectors);
                            if (selected) {
                              updated.add(sector);
                            } else {
                              updated.remove(sector);
                            }
                            onSectorsChanged(updated);
                          },
                        );
                      }).toList(),
                    ),
                    if (sectorsErrorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          text: sectorsErrorText!,
                          textSize: 12,
                          textColor: colors.error,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    const SizedBox(height: 16),
                    _Label('Years of Experience in Construction'),
                    InputField(
                      controller: yearsOfExperienceController,
                      hintText: 'e.g. 11',
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Team Size'),
                    InputField(
                      controller: teamSizeController,
                      hintText: 'Number of employees',
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Annual Revenue (JOD)'),
                    InputField(
                      controller: annualRevenueController,
                      hintText: 'Approximate last fiscal year',
                      keyboardType: TextInputType.number,
                      validator: _required,
                    ),
                    const SizedBox(height: 20),

                    // ── Banking Basics ───────────────────────────────
                    _SectionHeader('BANKING BASICS'),
                    _Label('Primary Bank Name'),
                    InputField(
                      controller: primaryBankNameController,
                      hintText: 'Select your bank',
                      readOnly: true,
                      onTap: onPickBank,
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('Bank Account Number (IBAN)'),
                    InputField(
                      controller: ibanNumberController,
                      hintText: 'e.g. JO94 ARAB 1234 5678',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),
                    _Label('SWIFT / BIC Code'),
                    InputField(controller: swiftBicCodeController, hintText: 'e.g. ARABJOAX', validator: _required),
                    const SizedBox(height: 16),
                    _Label('Bank Branch Name / City'),
                    InputField(
                      controller: bankBranchNameCityController,
                      hintText: 'e.g. Abdali Branch, Amman',
                      validator: _required,
                    ),
                    const SizedBox(height: 16),

                    AppText(
                      text:
                          'Your Trova classification (e.g. Class A – Large Enterprise) is calculated separately from this data and your Capability Score.',
                      textSize: 11,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                    ],
                  ),
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

  static String? _email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Enter a valid email';
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppText(
        text: text,
        textSize: 12,
        fontWeight: FontWeight.w600,
        textColor: colors.onSurfaceVariant,
        textAlign: TextAlign.start,
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
      child: AppText(
        text: text,
        textSize: 13,
        fontWeight: FontWeight.w600,
        textColor: colors.onSurface,
        textAlign: TextAlign.start,
      ),
    );
  }
}
