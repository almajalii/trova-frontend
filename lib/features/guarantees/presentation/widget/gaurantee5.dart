// guarantee_step5_documents_layout.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_shared.dart';

class GuaranteeStep5DocumentsLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep5DocumentsLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  Future<File?> _pickPdf() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
    );
    if (result == null || result.files.single.path == null) return null;
    return File(result.files.single.path!);
  }

  bool get _isValid => model.signedContractFile != null && model.letterOfAwardFile != null;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        AppTitle(
          title: 'Supporting Documents',
          size: 20,
          weight: FontWeight.w700,
          titleColor: colors.onSurface,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 20),
        _DocumentRow(
          title: 'Signed Contract / Agreement',
          subtitle: 'Required · PDF, max 10MB',
          file: model.signedContractFile,
          onUpload: () async {
            final f = await _pickPdf();
            if (f != null) onChanged(model.copyWith(signedContractFile: f));
          },
        ),
        const SizedBox(height: 12),
        _DocumentRow(
          title: 'Letter of Award',
          subtitle: 'Required · PDF, max 10MB',
          file: model.letterOfAwardFile,
          onUpload: () async {
            final f = await _pickPdf();
            if (f != null) onChanged(model.copyWith(letterOfAwardFile: f));
          },
        ),
        const SizedBox(height: 12),
        _DocumentRow(
          title: 'Other Supporting Documents',
          subtitle: 'Optional · PDF, max 10MB',
          file: model.otherDocuments.isNotEmpty ? model.otherDocuments.last : null,
          onUpload: () async {
            final f = await _pickPdf();
            if (f != null) {
              onChanged(model.copyWith(otherDocuments: [...model.otherDocuments, f]));
            }
          },
        ),
        const SizedBox(height: 8),
        Button(
          text: '+ Add another document',
          isText: true,
          textColor: colors.primary,
          borderRadius: 0,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          buttonWidth: 0,
          buttonHeight: 0,
          elevation: 0,
          onPressed: () async {
            final f = await _pickPdf();
            if (f != null) {
              onChanged(model.copyWith(otherDocuments: [...model.otherDocuments, f]));
            }
          },
        ),
        const SizedBox(height: 16),
        Button(
          text: 'Continue to Declarations',
          textColor: colors.onPrimary,
          borderRadius: 12,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          buttonWidth: double.infinity,
          buttonHeight: 47,
          elevation: 0,
          onPressed: _isValid ? onContinue : null,
        ),
      ],
    );
  }
}

class _DocumentRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final File? file;
  final VoidCallback onUpload;

  const _DocumentRow({
    required this.title,
    required this.subtitle,
    required this.file,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GuaranteeCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: title, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
                const SizedBox(height: 2),
                AppText(text: subtitle, textSize: 12, textColor: colors.secondary.withValues(alpha: 0.6), textAlign: TextAlign.start),
                if (file != null) ...[
                  const SizedBox(height: 4),
                  AppText(
                    text: file!.path.split('/').last,
                    textSize: 12,
                    textColor: colors.primary,
                    textAlign: TextAlign.start,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Button(
            text: file == null ? 'Upload' : 'Replace',
            isText: true,
            textColor: colors.primary,
            borderRadius: 0,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            buttonWidth: 0,
            buttonHeight: 0,
            elevation: 0,
            onPressed: onUpload,
          ),
        ],
      ),
    );
  }
}
