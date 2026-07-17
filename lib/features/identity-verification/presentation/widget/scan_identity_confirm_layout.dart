import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';

/// Editable counterpart to IdentityConfirmLayout, used only by the Scan-ID
/// path. OCR accuracy isn't guaranteed, so — unlike Sanad's read-only
/// confirm screen — the user needs to be able to correct whatever was
/// guessed before it's saved.
class ScanIdentityConfirmLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextEditingController nameController;
  final TextEditingController nationalIdController;
  final bool isSaving;
  final VoidCallback onBack;
  final VoidCallback onConfirm;

  const ScanIdentityConfirmLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.nameController,
    required this.nationalIdController,
    required this.isSaving,
    required this.onBack,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.vertical),

            IconButton(
              onPressed: isSaving ? null : onBack,
              icon: Icon(Icons.arrow_back, color: colors.onSurface),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),

            const SizedBox(height: 16),

            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
              child: Icon(Icons.check, color: colors.primary, size: 32),
            ),

            const SizedBox(height: 20),

            AppTitle(
              title: title,
              size: 22,
              weight: FontWeight.bold,
              titleColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 8),

            AppText(text: subtitle, textSize: 14, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),

            const SizedBox(height: 24),

            AppText(
              text: 'Full Name',
              textSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            _EditableField(controller: nameController, enabled: !isSaving),

            const SizedBox(height: 20),

            AppText(
              text: 'National ID (الرقم الوطني)',
              textSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            _EditableField(controller: nationalIdController, enabled: !isSaving, keyboardType: TextInputType.number),

            const Spacer(),

            Button(
              text: isSaving ? 'Saving...' : 'Confirm & Continue',
              textColor: colors.onPrimary,
              borderRadius: 12,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              elevation: 0,
              buttonWidth: double.infinity,
              buttonHeight: context.buttonSizeH,
              onPressed: isSaving ? null : onConfirm,
            ),

            SizedBox(height: context.vertical),
          ],
        ),
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputType? keyboardType;

  const _EditableField({required this.controller, required this.enabled, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 15, color: colors.onSurface),
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.surfaceBright, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.surfaceBright, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }
}
