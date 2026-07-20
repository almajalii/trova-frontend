import 'package:flutter/material.dart';
import 'package:trova/features/guarantee-review/presentation/widget/confirmation_layout.dart';
import 'package:trova/features/leave-review/presentation/screens/leave_review_screen.dart';

class WorkConfirmedScreen extends StatelessWidget {
  final String projectId;
  final String projectTitle;
  const WorkConfirmedScreen({super.key, required this.projectId, required this.projectTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmationLayout(
        isSuccess: true,
        title: 'Marked Complete',
        message: '$projectTitle has been moved to your project history as Completed.',
        buttonLabel: 'Done',
        onButtonPressed: () {
          // Figma's flow implies a "Leave a Review" step follows here (rate
          // the contractor). Push it on top rather than replace, so its own
          // back arrow returns here; its "Submit"/back then pops both
          // screens back to the project list.
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => LeaveReviewScreen(projectId: projectId))).then((
            _,
          ) {
            if (context.mounted) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          });
        },
      ),
    );
  }
}
