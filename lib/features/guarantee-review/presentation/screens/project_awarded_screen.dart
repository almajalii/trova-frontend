import 'package:flutter/material.dart';
import 'package:trova/features/guarantee-review/presentation/widget/confirmation_layout.dart';

class ProjectAwardedScreen extends StatelessWidget {
  final String projectTitle;
  final String contractorName;

  const ProjectAwardedScreen({super.key, required this.projectTitle, required this.contractorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmationLayout(
        isSuccess: true,
        title: 'Project Awarded',
        message: '$contractorName has been notified and can accept or decline within 48 hours.',
        buttonLabel: 'Done',
        // Bidders List / Compare Scores were both pushed on top of My Projects,
        // and the bottom nav clears the stack down to just that screen when
        // tapped — so popping back to the first route lands on My Projects.
        onButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
    );
  }
}
