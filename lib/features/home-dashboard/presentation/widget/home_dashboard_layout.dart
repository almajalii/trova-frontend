import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/score_ring.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/home-dashboard/logic/home_dashboard_model.dart';

class HomeDashboardLayout extends StatelessWidget {
  final HomeSummary summary;
  final VoidCallback onViewScoreBreakdown;
  final VoidCallback onBrowseProjects;
  final VoidCallback onPostProject;
  final VoidCallback onNotifications;

  const HomeDashboardLayout({
    super.key,
    required this.summary,
    required this.onViewScoreBreakdown,
    required this.onBrowseProjects,
    required this.onPostProject,
    required this.onNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 4, bottom: 24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(text: summary.greeting, textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
                    const SizedBox(height: 2),
                    AppText(
                      text: summary.userName,
                      textSize: 20,
                      fontWeight: FontWeight.w700,
                      textColor: colors.onSurface,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    StatusPill(text: summary.classification.display, fontSize: 11),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onNotifications,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: colors.surfaceBright)),
                  child: Icon(Icons.notifications_none_rounded, color: colors.primary, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _ScoreCard(summary: summary, onTap: onViewScoreBreakdown),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _QuickActionCard(icon: Icons.search, label: 'Browse Projects', onTap: onBrowseProjects)),
              const SizedBox(width: 12),
              Expanded(child: _QuickActionCard(icon: Icons.add, label: 'Post a Project', onTap: onPostProject)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(text: 'Eligible for You', textSize: 15, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
              AppText(text: 'See All', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.primary),
            ],
          ),
          const SizedBox(height: 8),
          for (final project in summary.eligibleProjects) ...[
            _EligibleProjectCard(project: project),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
          AppText(text: 'Recent Activity', textSize: 15, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
          const SizedBox(height: 12),
          for (final item in summary.recentActivity) ...[
            _ActivityRow(item: item),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final HomeSummary summary;
  final VoidCallback onTap;
  const _ScoreCard({required this.summary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            ScoreRing(score: summary.score.overall),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: summary.score.tierLabel, textSize: 15, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
                  const SizedBox(height: 4),
                  AppText(text: '▲ ${summary.score.monthlyChangePoints} pts this month', textSize: 12, textColor: AppColors.success, textAlign: TextAlign.start),
                  const SizedBox(height: 4),
                  AppText(text: 'View full breakdown  ›', textSize: 12, fontWeight: FontWeight.w600, textColor: colors.primary, textAlign: TextAlign.start),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickActionCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: colors.primary, size: 18),
            ),
            const SizedBox(height: 10),
            AppText(text: label, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
          ],
        ),
      ),
    );
  }
}

class _EligibleProjectCard extends StatelessWidget {
  final EligibleProjectSummary project;
  const _EligibleProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppText(text: project.title, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start)),
              StatusPill(text: project.sector, background: AppColors.neutralTagBg, foreground: colors.onSurfaceVariant, fontSize: 10, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              StatusPill(text: 'JOD ${(project.contractValueJod / 1000).toStringAsFixed(0)}K', fontSize: 11, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              const SizedBox(width: 8),
              StatusPill(text: '${project.daysLeft} days left', fontSize: 11, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityItem item;
  const _ActivityRow({required this.item});

  (Color, Color) _colorsFor(String status) {
    switch (status) {
      case 'ACTIVE':
        return (AppColors.successBg, AppColors.success);
      case 'PENDING':
        return (AppColors.warningBg, AppColors.warning);
      default:
        return (AppColors.neutralTagBg, AppColors.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (bg, fg) = _colorsFor(item.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(text: item.title, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
                const SizedBox(height: 2),
                AppText(text: item.subtitle, textSize: 12, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
              ],
            ),
          ),
          StatusPill(text: item.status[0] + item.status.substring(1).toLowerCase(), background: bg, foreground: fg, fontSize: 11, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
        ],
      ),
    );
  }
}