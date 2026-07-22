// guarantee_step5_documents_layout.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import '../../logic/guarantee_request_model.dart';

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
    final result = await FilePicker.platform.pickFiles(
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Supporting Documents', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _DocumentRow(
            title: 'Signed Contract / Agreement',
            subtitle: 'Required · PDF, max 10MB',
            file: model.signedContractFile,
            onUpload: () async {
              final f = await _pickPdf();
              if (f != null) onChanged(model.copyWith(signedContractFile: f));
            },
          ),
          _DocumentRow(
            title: 'Letter of Award',
            subtitle: 'Required · PDF, max 10MB',
            file: model.letterOfAwardFile,
            onUpload: () async {
              final f = await _pickPdf();
              if (f != null) onChanged(model.copyWith(letterOfAwardFile: f));
            },
          ),
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
          TextButton(
            onPressed: () async {
              final f = await _pickPdf();
              if (f != null) {
                onChanged(model.copyWith(otherDocuments: [...model.otherDocuments, f]));
              }
            },
            child: const Text('+ Add another document'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? onContinue : null,
              child: const Text('Continue to Declarations'),
            ),
          ),
        ],
      ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.surfaceBright),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                if (file != null)
                  Text(file!.path.split('/').last,
                      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          TextButton(onPressed: onUpload, child: Text(file == null ? 'Upload' : 'Replace')),
        ],
      ),
    );
  }
}