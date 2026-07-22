// bid_action_confirmation_screens.dart
//
// Confirmation screens shown after contractor bid actions, per Figma:
//  - "Work Submitted for Review" (after Mark Work as Done)
//  - "You've Backed Off" (after backing off a guarantee-rejected bid)
// Both end with "Back to My Bids", which rebuilds the My Bids stack so the
// list refetches with the new state.
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/routes.dart';

class WorkSubmittedScreen extends StatelessWidget {
  final String companyName;
  const WorkSubmittedScreen({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return _BidActionConfirmationView(
      badgeBg: const Color(0xFFFCEFD8),
      badgeIcon: Icons.hourglass_bottom,
      badgeIconColor: const Color(0xFFB8760B),
      title: 'Submitted for Review',
      message:
          "$companyName has been notified that work is complete. They'll review it and confirm.",
    );
  }
}

class BackedOffScreen extends StatelessWidget {
  final String companyName;
  const BackedOffScreen({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return _BidActionConfirmationView(
      badgeBg: const Color(0xFFFDE8E8),
      badgeIcon: Icons.close,
      badgeIconColor: const Color(0xFFC82333),
      title: "You've Backed Off",
      message:
          '$companyName has been notified. This bid is now closed and moved to your History.',
    );
  }
}

class _BidActionConfirmationView extends StatelessWidget {
  final Color badgeBg;
  final IconData badgeIcon;
  final Color badgeIconColor;
  final String title;
  final String message;

  const _BidActionConfirmationView({
    required this.badgeBg,
    required this.badgeIcon,
    required this.badgeIconColor,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
                child: Icon(badgeIcon, size: 36, color: badgeIconColor),
              ),
              const SizedBox(height: 28),
              AppTitle(
                title: title,
                size: 22,
                weight: FontWeight.bold,
                titleColor: colors.onSurface,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              AppText(
                text: message,
                textSize: 13,
                textColor: colors.secondary.withValues(alpha: 0.6),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              Button(
                text: 'Back to My Bids',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 47,
                elevation: 0,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.myBids,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
