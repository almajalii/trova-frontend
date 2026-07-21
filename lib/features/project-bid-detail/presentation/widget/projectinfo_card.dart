
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
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
          _buildRow(context, 'Sector', project.sector),
          _buildRow(context, 'Location', project.location),
          _buildRow(
            context,
            'Contract Value',
            'JOD ${project.contractValue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          ),
          _buildRow(context, 'Timeline', project.timeline),
          _buildRow(context, 'Milestones', project.milestones),
          _buildRow(context, 'Guarantee Type Required', project.guaranteeTypeRequired),
          _buildRow(context, 'Payment Terms', project.paymentTerms),
          _buildRow(context, 'Minimum Score', '${project.minimumScore}+'),
          _buildRow(context, 'Minimum Classification', project.minimumClassification),
          _buildRow(
            context,
            'Bid Deadline',
            '${_monthName(project.bidDeadline.month)} ${project.bidDeadline.day}, ${project.bidDeadline.year}',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {bool isLast = false}) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: AppText(
              text: label,
              textSize: 12,
              textColor: colors.onSecondary.withOpacity(0.6),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: AppText(
              text: value,
              textSize: 12,
              fontWeight: FontWeight.w600,
              textColor: colors.secondary,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
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
            child: AppText(
              text:
                  'By submitting this bid, your Capability Score and its underlying data will be visible to $postedBy for evaluation.',
              textSize: 12,
              textColor: const Color(0xFFC82333),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}