import 'package:flutter/material.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';
import 'package:trova/features/guarantee-review/presentation/widget/confirmation_layout.dart';

class GuaranteeVerifiedScreen extends StatelessWidget {
  final OwnerGuarantee guarantee;
  const GuaranteeVerifiedScreen({super.key, required this.guarantee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmationLayout(
        isSuccess: true,
        title: 'Guarantee Verified',
        message:
            'The guarantee for ${guarantee.projectTitle} is now active. ${guarantee.contractorName} can begin work.',
        buttonLabel: 'Done',
        onButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
    );
  }
}
