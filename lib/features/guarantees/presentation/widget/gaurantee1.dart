// guarantee_step1_applicant_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeStep1ApplicantLayout extends StatelessWidget {
  final GuaranteeRequestModel model;
  final ValueChanged<GuaranteeRequestModel> onChanged;
  final VoidCallback onContinue;

  const GuaranteeStep1ApplicantLayout({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = model.legalCompanyName != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Applicant (Contractor) Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text(
            'Auto-filled from your Trova profile.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (isFilled)
            _InfoCard(rows: {
              'Legal Company Name': model.legalCompanyName ?? '',
              'Registration Number (CR)': model.registrationNumber ?? '',
              'Tax / VAT Number': model.taxVatNumber ?? '',
              'Registered Address': model.registeredAddress ?? '',
              'Primary Contact': model.primaryContact ?? '',
              'Primary Email': model.primaryEmail ?? '',
              'Primary Phone': model.primaryPhone ?? '',
            })
          else
            const Text('Waiting on applicant details...', style: TextStyle(color: Colors.grey)),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isFilled ? onContinue : null,
              child: const Text('Continue to Project Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Map<String, String> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
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
