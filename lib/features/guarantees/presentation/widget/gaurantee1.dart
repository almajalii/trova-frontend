// guarantee_step1_applicant_layout.dart
import 'package:flutter/material.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeStep1ApplicantLayout extends StatefulWidget {
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
  State<GuaranteeStep1ApplicantLayout> createState() => _GuaranteeStep1ApplicantLayoutState();
}

class _GuaranteeStep1ApplicantLayoutState extends State<GuaranteeStep1ApplicantLayout> {
  late final TextEditingController _contractorIdController =
      TextEditingController(text: widget.model.contractorId);

  void _autoFill(String contractorId) {
    // TODO: replace with real lookup call (likely from your Trova profile service)
    widget.onChanged(widget.model.copyWith(
      contractorId: contractorId,
      legalCompanyName: 'Al-Fahad Contracting L',
      registrationNumber: 'JO-CR-1',
      taxVatNumber: 'JO-TAX-994512',
      registeredAddress: 'Wadi Saqra, Amman, Jordan',
      primaryContact: 'Ahmad Khalil, Operations Director',
      primaryEmail: 'ahmad.khalil@alfahad.jo',
      primaryPhone: '+962 79 123 4567',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.model.legalCompanyName != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Applicant (Contractor) Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Contractor ID'),
          const SizedBox(height: 8),
          TextField(
            controller: _contractorIdController,
            decoration: const InputDecoration(
              hintText: 'Enter your Contractor ID to auto-fill',
              border: OutlineInputBorder(),
            ),
            onSubmitted: _autoFill,
          ),
          const SizedBox(height: 4),
          const Text(
            'Entering your Contractor ID auto-fills the fields below from your Trova profile.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (isFilled)
            _InfoCard(rows: {
              'Legal Company Name': widget.model.legalCompanyName ?? '',
              'Registration Number (CR)': widget.model.registrationNumber ?? '',
              'Tax / VAT Number': widget.model.taxVatNumber ?? '',
              'Registered Address': widget.model.registeredAddress ?? '',
              'Primary Contact': widget.model.primaryContact ?? '',
              'Primary Email': widget.model.primaryEmail ?? '',
              'Primary Phone': widget.model.primaryPhone ?? '',
            }),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isFilled ? widget.onContinue : null,
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