import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/post-project/logic/post_project_model.dart';

class PostAProjectLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  // Controllers
  final TextEditingController titleController;
  final TextEditingController locationController;
  final TextEditingController valueController;
  final TextEditingController durationController;
  final TextEditingController milestonesController;
  final TextEditingController deadlineController;
  final TextEditingController minScoreController;
  final TextEditingController paymentTermsController;
  final TextEditingController descriptionController;

  // Dropdown States & Callbacks
  final String? sector;
  final ValueChanged<String?> onSectorChanged;
  final String currency;
  final ValueChanged<String?> onCurrencyChanged;
  final ClassificationCode minClassification;
  final ValueChanged<ClassificationCode> onClassificationChanged;
  final String? guaranteeType;
  final ValueChanged<String?> onGuaranteeTypeChanged;

  // Actions
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const PostAProjectLayout({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.locationController,
    required this.valueController,
    required this.durationController,
    required this.milestonesController,
    required this.deadlineController,
    required this.minScoreController,
    required this.paymentTermsController,
    required this.descriptionController,
    required this.sector,
    required this.onSectorChanged,
    required this.currency,
    required this.onCurrencyChanged,
    required this.minClassification,
    required this.onClassificationChanged,
    required this.guaranteeType,
    required this.onGuaranteeTypeChanged,
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
                child: ListView(
                  children: [
                    AppTitle(
                      title: 'Post a Project',
                      size: 24,
                      weight: FontWeight.w700,
                      titleColor: colors.onSurface,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text: 'Define your project so qualified contractors can bid.',
                      textSize: 14,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 20),

                    // --- Project Title ---
                    _Label('Project Title'),
                    InputField(
                      controller: titleController,
                      hintText: 'e.g. Al-Noor Tower Construction',
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 18),

                    // --- Sector ---
                    _Label('Sector'),
                    _AppDropdown(
                      value: sector,
                      hint: 'Select a sector (e.g. Construction)',
                      items: const ['Construction', 'Engineering', 'IT', 'Consulting', 'Other'],
                      onChanged: onSectorChanged,
                    ),
                    const SizedBox(height: 18),

                    // --- Location ---
                    _Label('Location'),
                    InputField(
                      controller: locationController,
                      hintText: 'e.g. Amman, Abdali District',
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 18),

                    // --- Contract Value & Currency ---
                    _Label('Contract Value'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InputField(
                            controller: valueController,
                            hintText: 'Enter estimated value',
                            keyboardType: TextInputType.number,
                            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: _AppDropdown(
                            value: currency,
                            hint: 'JOD',
                            items: const ['JOD', 'USD', 'EUR'],
                            onChanged: onCurrencyChanged,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // --- Project Timeline / Duration ---
                    _Label('Project Timeline / Duration'),
                    InputField(controller: durationController, hintText: 'e.g. 14 months (Aug 2026 – Oct 2027)'),
                    const SizedBox(height: 18),

                    // --- Project Milestones ---
                    _Label('Project Milestones'),
                    InputField(
                      controller: milestonesController,
                      hintText: 'e.g. Foundation – Month 2, Structure – Month 8...',
                      maxLines: 4,
                      minLines: 2,
                    ),
                    const SizedBox(height: 18),

                    // --- Bid Submission Deadline ---
                    _Label('Bid Submission Deadline'),
                    InputField(controller: deadlineController, hintText: 'e.g. August 15, 2026'),
                    const SizedBox(height: 18),

                    // --- Minimum Required Score ---
                    _Label('Minimum Required Score'),
                    InputField(
                      controller: minScoreController,
                      hintText: 'e.g. 80+',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 18),

                    // --- Minimum Contractor Classification ---
                    _Label('Minimum Contractor Classification'),
                    _ClassificationDropdown(value: minClassification, onChanged: onClassificationChanged),
                    const SizedBox(height: 18),

                    // --- Guarantee Type Required ---
                    _Label('Guarantee Type Required'),
                    _AppDropdown(
                      value: guaranteeType,
                      hint: 'Select one: Performance, Advance Payment...',
                      items: const [
                        'Performance Guarantee',
                        'Advance Payment Guarantee',
                        'Bid Bond Guarantee',
                        'Retention Guarantee',
                      ],
                      onChanged: onGuaranteeTypeChanged,
                    ),
                    const SizedBox(height: 18),

                    // --- Payment Terms ---
                    _Label('Payment Terms'),
                    InputField(
                      controller: paymentTermsController,
                      hintText: 'e.g. 20% upfront / 60% at milestones / 20% on completion',
                    ),
                    const SizedBox(height: 18),

                    // --- Project Description ---
                    _Label('Project Description'),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      style: TextStyle(color: colors.onSurface, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Scope, timeline, and requirements...',
                        hintStyle: TextStyle(color: colors.surfaceBright, fontSize: 15, fontWeight: FontWeight.w500),
                        filled: true,
                        fillColor: colors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.surfaceBright),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.surfaceBright),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.primary, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Bottom padding for scroll
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Button(
                text: isLoading ? 'Posting...' : 'Post Project',
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

// Reusable dropdown for generic String lists
class _AppDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _AppDropdown({required this.value, required this.hint, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 52, // Typical height to match InputField
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: colors.surfaceBright, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: colors.onSurface),
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.onSurface),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ClassificationDropdown extends StatelessWidget {
  final ClassificationCode value;
  final ValueChanged<ClassificationCode> onChanged;

  const _ClassificationDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.surfaceBright),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassificationCode>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: colors.onSurface),
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.onSurface),
          items: ClassificationCode.values
              .map((c) => DropdownMenuItem(value: c, child: Text(c.dropdownLabel)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
