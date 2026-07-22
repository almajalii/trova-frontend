// guarantee_step2_project_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

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
    final isFilled = model.projectName != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Project ID'),
          const SizedBox(height: 8),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              hintText: model.projectId ?? 'TRV-PRJ-xxxxx (auto-linked to this bid)',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          if (isFilled)
            _ProjectCard(model: model)
          else
            const Text('Waiting on project link...', style: TextStyle(color: Colors.grey)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isFilled ? onContinue : null,
              child: const Text('Continue to Guarantee Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final GuaranteeRequestModel model;
  const _ProjectCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final rows = {
      'Project Name': model.projectName ?? '',
      'Location': model.location ?? '',
      'Contract Value': model.contractValue != null ? 'JOD ${model.contractValue}' : '',
      'Description': model.description ?? '',
      'Contract Duration': model.contractDuration ?? '',
    };
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.surfaceBright),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: rows.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: Text(e.key, style: const TextStyle(color: Colors.grey))),
                Expanded(
                  flex: 3,
                  child: Text(e.value,
                      textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}