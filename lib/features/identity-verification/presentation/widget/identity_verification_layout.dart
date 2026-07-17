import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IdentityVerificationLayout extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSanadTap;
  final VoidCallback onScanTap;

  const IdentityVerificationLayout({
    super.key,
    required this.onBack,
    required this.onSanadTap,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.vertical),

            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back, color: colors.onSurface),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),

            const SizedBox(height: 8),

            AppTitle(
              title: 'Verify Your Identity',
              size: 26,
              weight: FontWeight.bold,
              titleColor: colors.onSurface,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 8),

            AppText(
              text: 'We need to confirm your National ID to activate your account.',
              textSize: 14,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 32),

            _VerificationOptionCard(
              icon: SvgPicture.asset(
                'assets/images/auth/Sanad.svg',
                width: 24,
                height: 24,
              ),
              title: 'Continue with Sanad',
              subtitle: 'Verify instantly using your Sanad government account.',
              onTap: onSanadTap,
            ),

            const SizedBox(height: 16),

            _VerificationOptionCard(
              icon: Icon(Icons.badge_outlined, color: colors.primary),
              title: 'Scan National ID',
              subtitle: "Take a photo of your ID card's front side.",
              onTap: onScanTap,
            ),

            const Spacer(),

            AppText(
              text: 'Your ID is used only to verify your identity and is handled securely.',
              textSize: 12,
              textColor: colors.onSurfaceVariant,
              textAlign: TextAlign.start,
            ),

            SizedBox(height: context.vertical),
          ],
        ),
      ),
    );
  }
}

class _VerificationOptionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _VerificationOptionCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.surfaceBright, width: 1),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: colors.primary.withValues(alpha: 0.1),
                child: icon,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: title,
                      textSize: 15,
                      fontWeight: FontWeight.w600,
                      textColor: colors.onSurface,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: subtitle,
                      textSize: 12,
                      textColor: colors.onSurfaceVariant,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
