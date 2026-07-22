import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/status_pill.dart';
import 'package:trova/features/company-profile/logic/company_profile_model.dart';
import 'package:trova/features/company-profile/logic/company_reviews_model.dart';

class CompanyProfileLayout extends StatelessWidget {
  final CompanyProfile profile;
  final VoidCallback onEdit;
  final VoidCallback onSettings;

  const CompanyProfileLayout({
    super.key,
    required this.profile,
    required this.onEdit,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final details = profile.details;
    final score = profile.score;

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 32),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onEdit,
                child: AppText(text: 'Edit', textSize: 14, fontWeight: FontWeight.w600, textColor: colors.primary),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onSettings,
                icon: Icon(Icons.settings_outlined, color: colors.onSurfaceVariant),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(20)),
              child: Text(
                _initialsOf(details.legalCompanyName),
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 26, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            text: details.legalCompanyName,
            textSize: 20,
            fontWeight: FontWeight.w700,
            textColor: colors.onSurface,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Center(child: StatusPill(text: details.classification.display)),
          if (score != null) ...[
            const SizedBox(height: 8),
            Center(child: StatusPill(text: 'Score: ${score.overallScore} · ${score.tierLabel}')),
          ],
          const SizedBox(height: 24),

          _SectionHeader('COMPANY LEGAL INFO'),
          _DetailCard(
            rows: [
              _DetailRow('Legal Company Name', details.legalCompanyName),
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
          const SizedBox(height: 20),

          _SectionHeader('BANKING BASICS'),
          _DetailCard(
            rows: [
              _DetailRow('Primary Bank Name', details.primaryBankName),
              _DetailRow('Bank Account Number (IBAN)', details.ibanNumber),
              _DetailRow('SWIFT / BIC Code', details.swiftBicCode),
              _DetailRow('Bank Branch Name / City', details.bankBranchNameCity),
            ],
          ),
          const SizedBox(height: 20),

          if (score != null) ...[
            _SectionHeader('TRACK RECORD'),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    value: '${score.trackRecordStats.totalProjects}',
                    label: 'Total Projects',
                    bg: AppColors.neutralStatBg,
                    valueColor: colors.onSurface,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    value: '${score.trackRecordStats.currentProjects}',
                    label: 'Current Projects',
                    bg: AppColors.warningBg,
                    valueColor: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    value: '${score.trackRecordStats.failedProjects}',
                    label: 'Failed Projects',
                    bg: AppColors.dangerBg,
                    valueColor: AppColors.danger,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatTile(
                    value: score.trackRecordStats.avgRating.toStringAsFixed(1),
                    label: 'Avg. Rating',
                    bg: AppColors.successBg,
                    valueColor: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          _SectionHeader('REVIEWS'),
          _ReviewsSummaryCard(reviews: profile.reviews),
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
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppText(
        text: text,
        textSize: 12,
        fontWeight: FontWeight.w600,
        textColor: colors.onSurfaceVariant,
        textAlign: TextAlign.start,
      ),
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
                  Expanded(
                    child: AppText(
                      text: rows[i].label,
                      textSize: 13,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                  ),
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

class _ReviewsSummaryCard extends StatelessWidget {
  final CompanyReviewsSummary reviews;
  const _ReviewsSummaryCard({required this.reviews});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: AppColors.primaryTint, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(
            reviews.averageRating.toStringAsFixed(1),
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w800, fontSize: 32, color: colors.primary),
          ),
          const SizedBox(height: 6),
          _StarRow(filledStars: reviews.averageRating.round(), color: colors.primary),
          const SizedBox(height: 6),
          AppText(
            text: 'Based on ${reviews.totalReviews} reviews',
            textSize: 12,
            textColor: colors.onSurfaceVariant,
          ),
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
              Expanded(
                child: AppText(
                  text: review.reviewerName,
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
              ),
              _StarRow(filledStars: review.stars, color: colors.primary, size: 14),
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

class _StarRow extends StatelessWidget {
  final int filledStars;
  final Color color;
  final double size;
  const _StarRow({required this.filledStars, required this.color, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < filledStars;
        return Icon(filled ? Icons.star : Icons.star_border, size: size, color: color);
      }),
    );
  }
}
