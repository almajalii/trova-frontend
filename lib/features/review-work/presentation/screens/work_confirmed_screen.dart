import 'package:flutter/material.dart';
import 'package:trova/features/guarantee-review/presentation/widget/confirmation_layout.dart';

class WorkConfirmedScreen extends StatelessWidget {
  final String projectTitle;
  const WorkConfirmedScreen({super.key, required this.projectTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmationLayout(
        isSuccess: true,
        title: 'Marked Complete',
        message: '$projectTitle has been moved to your project history as Completed.',
        buttonLabel: 'Done',
        // NOTE: Figma's flow implies a "Leave a Review" step should follow
        // here (rate the contractor) — that screen isn't built yet, so this
        // goes straight back rather than routing somewhere unfinished.
        onButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
    );
  }
}
