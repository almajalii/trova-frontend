// guarantee_submitted_screen.dart
import 'package:flutter/material.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/routes.dart';

class GuaranteeSubmittedScreen extends StatelessWidget {
  const GuaranteeSubmittedScreen({super.key});

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
                decoration: const BoxDecoration(
                  color: Color(0xFFFCEFD8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_bottom, size: 36, color: Color(0xFFB8760B)),
              ),
              const SizedBox(height: 28),
              AppTitle(
                title: 'Submitted to Bank',
                size: 22,
                weight: FontWeight.bold,
                titleColor: colors.onSurface,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              AppText(
                text: "Your guarantee application is pending bank review. You'll be notified once it's issued.",
                textSize: 13,
                textColor: colors.secondary.withValues(alpha: 0.6),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
              Button(
                text: 'Back to Dashboard',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                buttonWidth: double.infinity,
                buttonHeight: 47,
                elevation: 0,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.homeDashboard,
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
