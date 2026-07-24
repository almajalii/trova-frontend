import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/owner-profile/logic/owner_profile_model.dart';

class OwnerProfileLayout extends StatelessWidget {
  final OwnerFullProfile profile;
  final VoidCallback onBack;

  const OwnerProfileLayout({super.key, required this.profile, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final details = profile.details;
    final stats = profile.stats;

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
                _initialsOf(profile.companyName),
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, fontSize: 26, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(height: 14),
          AppText(
            text: profile.companyName,
            textSize: 20,
            fontWeight: FontWeight.w700,
            textColor: colors.onSurface,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          AppText(
            text: 'Project Owner',
            textSize: 13,
            textColor: colors.onSurfaceVariant,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          _SectionHeader('COMPANY LEGAL INFO'),
          _DetailCard(
            rows: [
              _DetailRow('Legal Company Name', profile.companyName),
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
              _DetailRow('Main Areas of Business', details.sectorsPosted.join(', ')),
              _DetailRow('Years of Experience', '${details.yearsOfExperience}'),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '${stats.totalProjectsPosted}',
                  label: 'Total Projects Posted',
                  bg: AppColors.neutralStatBg,
                  valueColor: colors.onSurface,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  value: '${stats.activeProjects}',
                  label: 'Active Projects',
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
                  value: '${stats.completedProjects}',
                  label: 'Completed Projects',
                  bg: AppColors.successBg,
                  valueColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  // No contractor-reviews-owner flow exists yet, so the
                  // backend always sends 0.0 here for now — that's "not
                  // rated yet", not "rated zero", so show it as such
                  // instead of a green 0.0 that reads as a real bad score.
                  value: stats.avgRating > 0 ? stats.avgRating.toStringAsFixed(1) : '—',
                  label: stats.avgRating > 0 ? 'Avg. Rating' : 'No Rating Yet',
                  bg: stats.avgRating > 0 ? AppColors.successBg : AppColors.neutralStatBg,
                  valueColor: stats.avgRating > 0 ? AppColors.success : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
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
