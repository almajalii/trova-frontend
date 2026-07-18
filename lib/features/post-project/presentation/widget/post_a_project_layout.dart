import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/post-project/logic/post_project_model.dart';

class PostAProjectLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController valueController;
  final TextEditingController minScoreController;
  final TextEditingController descriptionController;
  final ClassificationCode minClassification;
  final ValueChanged<ClassificationCode> onClassificationChanged;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const PostAProjectLayout({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.valueController,
    required this.minScoreController,
    required this.descriptionController,
    required this.minClassification,
    required this.onClassificationChanged,
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
                    AppTitle(title: 'Post a Project', size: 24, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
                    const SizedBox(height: 8),
                    AppText(text: 'Define your project so qualified contractors can bid.', textSize: 14, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
                    const SizedBox(height: 20),
                    _Label('Project Title'),
                    InputField(controller: titleController, hintText: 'e.g. Al-Noor Tower Construction', validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                    const SizedBox(height: 18),
                    _Label('Contract Value (JOD)'),
                    InputField(controller: valueController, hintText: 'Enter estimated value', keyboardType: TextInputType.number, validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                    const SizedBox(height: 18),
                    _Label('Minimum Required Score'),
                    InputField(controller: minScoreController, hintText: 'e.g. 80+', keyboardType: TextInputType.number),
                    const SizedBox(height: 18),
                    _Label('Minimum Contractor Classification'),
                    _ClassificationDropdown(value: minClassification, onChanged: onClassificationChanged),
                    const SizedBox(height: 18),
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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.surfaceBright)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.surfaceBright)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colors.primary, width: 1.5)),
                      ),
                    ),
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
      child: AppText(text: text, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
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
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: colors.surface, border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassificationCode>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.expand_more, color: colors.onSurface),
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: colors.onSurface),
          items: ClassificationCode.values.map((c) => DropdownMenuItem(value: c, child: Text(c.dropdownLabel))).toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
