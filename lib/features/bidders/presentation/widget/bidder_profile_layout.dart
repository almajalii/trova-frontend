import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/factor_progress_bar.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/score_ring.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/bidders/logic/bidder_profile_model.dart';
import 'package:trova/features/company-profile/logic/company_reviews_model.dart';

/// Full profile of a bidding company, reached by tapping a card on Compare
/// Scores. Legal/contact/qualifications info, track record stats, and
/// reviews are mocked (no public-profile endpoint exists yet — see
/// bidder_profile_service.dart), but the score breakdown is derived from
/// the same subFactors already shown on Compare Scores, so it can never
/// disagree with what the user just compared.
class BidderProfileLayout extends StatelessWidget {
  final BidderFullProfile profile;
  final VoidCallback onBack;

  const BidderProfileLayout({super.key, required this.profile, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bidder = profile.bidder;
    final details = profile.details;
    final stats = profile.trackRecordStats;
    final breakdown = profile.scoreBreakdown;

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 32),
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(20)),
              child: Text(
                _initialsOf(bidder.companyName),
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 26, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            text: bidder.companyName,
            textSize: 20,
            fontWeight: FontWeight.w700,
            textColor: colors.onSurface,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Center(
            child: StatusPill(
              text: bidder.eligible
                  ? 'Class ${bidder.classification}'
                  : 'Class ${bidder.classification} - Below required tier',
              background: bidder.eligible ? AppColors.neutralTagBg : AppColors.dangerBg,
              foreground: bidder.eligible ? colors.onSurfaceVariant : AppColors.danger,
            ),
          ),
          const SizedBox(height: 20),
          Center(child: ScoreRing(score: bidder.capabilityScore, size: 140, strokeWidth: 11, fontSize: 34)),
          const SizedBox(height: 10),
          Center(
            child: AppText(
              text: _tierLabelFor(bidder.capabilityScore),
              textSize: 14,
              fontWeight: FontWeight.w600,
              textColor: colors.primary,
            ),
          ),
          const SizedBox(height: 24),

          _SectionHeader('COMPANY LEGAL INFO'),
          _DetailCard(
            rows: [
              _DetailRow('Legal Company Name', bidder.companyName),
              _DetailRow('Trading Name (DBA)', details.tradingName),
              _DetailRow('Registration Number (CR)', details.registrationNumber),
              _DetailRow('Tax / VAT Number', details.taxVatNumber),
              _DetailRow('Company Legal Structure', details.legalStructure),
              _DetailRow('Year of Establishment', '${details.yearOfEstablishment}'),
              _DetailRow('Registered Address', details.registeredAddress),
              _DetailRow('Country of Registration', details.countryOfRegistration),
            ],
          ),
          const SizedBox(height: 20),

          _SectionHeader('CONTACT INFORMATION'),
          _DetailCard(
            rows: [
              _DetailRow('Primary Contact Person', details.primaryContactName),
              _DetailRow('Position / Title', details.positionTitle),
              _DetailRow('Primary Email', details.primaryEmail),
              _DetailRow('Primary Phone Number', details.primaryPhoneNumber),
            ],
          ),
          const SizedBox(height: 20),

          _SectionHeader('BUSINESS QUALIFICATIONS'),
          _DetailCard(
            rows: [
              _DetailRow('Commercial License Number', details.businessLicenseNumber),
              _DetailRow('Contractor Classification / Grade', details.contractorClassificationGrade),
              _DetailRow('Main Areas of Expertise', details.sectors.join(', ')),
              _DetailRow('Years of Experience', '${details.yearsOfExperience}'),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(child: _StatTile(value: '${stats.totalProjects}', label: 'Total Projects', bg: AppColors.neutralStatBg, valueColor: colors.onSurface)),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(value: '${stats.currentProjects}', label: 'Current Projects', bg: AppColors.warningBg, valueColor: AppColors.warning)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _StatTile(value: '${stats.failedProjects}', label: 'Failed Projects', bg: AppColors.dangerBg, valueColor: AppColors.danger)),
              const SizedBox(width: 10),
              Expanded(child: _StatTile(value: stats.avgRating.toStringAsFixed(1), label: 'Avg. Rating', bg: AppColors.successBg, valueColor: AppColors.success)),
            ],
          ),
          const SizedBox(height: 24),

          AppText(text: 'Score Breakdown', textSize: 15, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
          const SizedBox(height: 14),
          FactorProgressBar(label: 'Financial Solvency', percentage: breakdown.financialSolvencyPct),
          const SizedBox(height: 18),
          FactorProgressBar(label: 'Project Track Record', percentage: breakdown.projectTrackRecordPct),
          const SizedBox(height: 18),
          FactorProgressBar(label: 'Past Project Ratings', percentage: breakdown.pastProjectRatingsPct),
          const SizedBox(height: 24),

          AppText(text: 'Recent Reviews', textSize: 15, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start),
          const SizedBox(height: 12),
          for (final review in profile.reviews.items) ...[
            _ReviewCard(review: review),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  static String _initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    final initials = words.take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
    return initials.isEmpty ? '?' : initials;
  }

  static String _tierLabelFor(int score) {
    if (score >= 90) return 'Strong Capability';
    if (score >= 75) return 'Good Capability';
    if (score >= 60) return 'Moderate Capability';
    return 'Needs Improvement';
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppText(text: text, textSize: 12, fontWeight: FontWeight.w600, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);
}

class _DetailCard extends StatelessWidget {
  final List<_DetailRow> rows;
  const _DetailCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AppText(text: rows[i].label, textSize: 13, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      text: rows[i].value.isEmpty ? '—' : rows[i].value,
                      textSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.onSurface,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
            if (i != rows.length - 1) Divider(height: 1, color: colors.surfaceBright),
          ],
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

class _ReviewCard extends StatelessWidget {
  final CompanyReviewItem review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: AppText(text: review.reviewerName, textSize: 14, fontWeight: FontWeight.w600, textColor: colors.onSurface, textAlign: TextAlign.start)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) => Icon(i < review.stars ? Icons.star : Icons.star_border, size: 14, color: colors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          AppText(text: review.projectTitle, textSize: 12, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
          const SizedBox(height: 8),
          AppText(text: review.comment, textSize: 13, textColor: colors.onSurface, textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
