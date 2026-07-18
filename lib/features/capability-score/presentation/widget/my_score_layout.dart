import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/factor_progress_bar.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/score_ring.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';

class MyScoreLayout extends StatelessWidget {
  final CapabilityScore score;
  final VoidCallback onBack;

  const MyScoreLayout({super.key, required this.score, required this.onBack});

  String _jod(double v) => 'JOD ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 40),
        children: [
          IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back, color: colors.onSurface), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          const SizedBox(height: 8),
          AppTitle(title: 'Your Capability Score', size: 20, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          Center(child: ScoreRing(score: score.overallScore, size: 160, strokeWidth: 12, fontSize: 40)),
          const SizedBox(height: 12),
          Center(child: AppText(text: score.tierLabel, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.primary)),
          const SizedBox(height: 10),
          Center(child: StatusPill(text: score.classification.display)),
          const SizedBox(height: 22),
          AppText(text: 'Score Breakdown', textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _StatTile(value: '${score.trackRecordStats.totalProjects}', label: 'Total Projects', bg: AppColors.neutralStatBg, valueColor: colors.onSurface)),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(value: '${score.trackRecordStats.failedProjects}', label: 'Failed Projects', bg: AppColors.dangerBg, valueColor: AppColors.danger)),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(value: score.trackRecordStats.avgRating.toStringAsFixed(1), label: 'Avg. Rating', bg: AppColors.successBg, valueColor: AppColors.success)),
            ],
          ),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.financialSolvency.label, percentage: score.financialSolvency.percentage, description: score.financialSolvency.description),
          const SizedBox(height: 16),
          _OpenFinanceDetailsCard(data: score.openFinanceData, jod: _jod),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.projectTrackRecord.label, percentage: score.projectTrackRecord.percentage, description: score.projectTrackRecord.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.pastProjectRatings.label, percentage: score.pastProjectRatings.percentage, description: score.pastProjectRatings.description),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color bg;
  final Color valueColor;
  const _StatTile({required this.value, required this.label, required this.bg, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 18, color: valueColor)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _OpenFinanceDetailsCard extends StatelessWidget {
  final OpenFinanceData data;
  final String Function(double) jod;
  const _OpenFinanceDetailsCard({required this.data, required this.jod});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(text: 'Open Finance Data', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
          const SizedBox(height: 10),
          _Row('Current Outstanding Debt', jod(data.currentOutstandingDebtJod), colors.onSurface),
          const SizedBox(height: 10),
          _Row('Additional Borrowing Capacity', jod(data.additionalBorrowingCapacityJod), colors.onSurface),
          const SizedBox(height: 10),
          _Row('Value of Existing Assets', jod(data.valueOfExistingAssetsJod), colors.onSurface),
          const SizedBox(height: 10),
          Divider(height: 1, color: colors.surfaceBright),
          const SizedBox(height: 10),
          AppText(text: 'From Bank (via Open Finance)', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
          const SizedBox(height: 10),
          _Row('Distressed / Defaulted Debt', jod(data.distressedDebtJod), AppColors.success),
          const SizedBox(height: 10),
          _Row('Debt Payments Settled', '${data.debtPaymentsSettled}', colors.onSurface),
          const SizedBox(height: 10),
          _Row('Late Payments', '${data.latePayments}', data.latePayments > 0 ? AppColors.danger : colors.onSurface),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _Row(this.label, this.value, this.valueColor);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: AppText(text: label, textSize: 13, textColor: colors.onSurface, textAlign: TextAlign.start)),
        AppText(text: value, textSize: 13, fontWeight: FontWeight.w600, textColor: valueColor),
      ],
    );
  }
}
