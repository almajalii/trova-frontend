import 'package:flutter/material.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';

class ProjectInfoCard extends StatelessWidget {
  final Project project;

  const ProjectInfoCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.surfaceBright),
      ),
      child: Column(
        children: [
          _buildRow('Sector', project.sector),
          _buildRow('Location', project.location),
          _buildRow(
            'Contract Value',
            'JOD ${project.contractValueJod.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          ),
          _buildRow('Timeline', project.timelineText),
          _buildRow('Milestones', project.milestones),
          _buildRow('Guarantee Type Required', project.guaranteeTypeRequired),
          _buildRow('Payment Terms', project.paymentTerms),
          _buildRow('Minimum Score', '${project.minimumRequiredScore}+'),
          _buildRow('Minimum Classification', project.minimumClassificationText),
          _buildRow(
            'Bid Deadline',
            project.bidDeadlineText,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF504D4D),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BidWarningBox extends StatelessWidget {
  final String postedBy;

  const BidWarningBox({super.key, required this.postedBy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE8E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: Color(0xFFC82333),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'By submitting this bid, your Capability Score and its underlying data will be visible to $postedBy for evaluation.',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFC82333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}