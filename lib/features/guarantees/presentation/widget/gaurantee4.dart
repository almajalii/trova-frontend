// guarantee_step4_beneficiary_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeStep4BeneficiaryLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep4BeneficiaryLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Beneficiary (Project Owner) Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            "Auto-filled from the Project ID. Edit if this project has multiple owners.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.surfaceBright),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: {
                'Beneficiary ID (Optional)': model.beneficiaryId ?? '',
                'Company Name': model.beneficiaryCompanyName ?? '',
                'Registered Address': model.beneficiaryAddress ?? '',
                'Contact Person': model.beneficiaryContact ?? '',
                'Email': model.beneficiaryEmail ?? '',
                'Phone (Optional)': model.beneficiaryPhone ?? '',
              }.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: Text(e.key, style: const TextStyle(color: Colors.grey))),
                      Expanded(
                        flex: 3,
                        child: Text(e.value,
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // TODO: open an edit sheet/dialog to modify beneficiary fields
            },
            child: const Text('Edit Beneficiary Details'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              child: const Text('Continue to Documents'),
            ),
          ),
        ],
      ),
    );
  }
}