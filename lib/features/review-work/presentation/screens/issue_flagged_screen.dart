import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/features/guarantee-review/presentation/widget/confirmation_layout.dart';

class IssueFlaggedScreen extends StatelessWidget {
  const IssueFlaggedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmationLayout(
        isSuccess: false, // unused when badge is provided, kept for clarity
        badge: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(color: AppColors.warningBg, shape: BoxShape.circle),
          child: const Icon(Icons.priority_high, color: AppColors.warning, size: 30),
        ),
        title: 'Issue Flagged',
        message:
            "This project is now marked as Disputed. Trova's team will step in to help resolve it with both parties.",
        buttonLabel: 'Back to My Projects',
        onButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
    );
  }
}
