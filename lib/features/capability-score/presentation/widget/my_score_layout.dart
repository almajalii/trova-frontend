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
          FactorProgressBar(label: score.numberOfCurrentDebts.label, percentage: score.numberOfCurrentDebts.percentage, description: score.numberOfCurrentDebts.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.debtCapacity.label, percentage: score.debtCapacity.percentage, description: score.debtCapacity.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.companyAssetsValue.label, percentage: score.companyAssetsValue.percentage, description: score.companyAssetsValue.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.delinquentDebts.label, percentage: score.delinquentDebts.percentage, description: score.delinquentDebts.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.paymentHistory.label, percentage: score.paymentHistory.percentage, description: score.paymentHistory.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.currentWorkload.label, percentage: score.currentWorkload.percentage, description: score.currentWorkload.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.projectDeliveryHistory.label, percentage: score.projectDeliveryHistory.percentage, description: score.projectDeliveryHistory.description),
          const SizedBox(height: 20),
          FactorProgressBar(label: score.cashflowTrends.label, percentage: score.cashflowTrends.percentage, description: score.cashflowTrends.description),
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
