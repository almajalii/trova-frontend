import 'package:flutter/material.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';
import 'package:trova/features/guarantee-review/presentation/widget/confirmation_layout.dart';

class GuaranteeRejectedScreen extends StatelessWidget {
  final OwnerGuarantee guarantee;
  const GuaranteeRejectedScreen({super.key, required this.guarantee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmationLayout(
        isSuccess: false,
        title: 'Guarantee Rejected',
        message:
            '${guarantee.contractorName} has been notified. They can resubmit a new guarantee, or you can post the project again.',
        buttonLabel: 'Done',
        onButtonPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      ),
    );
  }
}
