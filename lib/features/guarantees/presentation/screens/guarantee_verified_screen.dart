import 'package:flutter/material.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';
import 'package:trova/features/guarantees/presentation/widget/guarantee_verified_layout.dart';

class GuaranteeVerifiedScreen extends StatelessWidget {
  final Guarantee guarantee;
  const GuaranteeVerifiedScreen({super.key, required this.guarantee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GuaranteeVerifiedLayout(
        guarantee: guarantee,
        onBack: () => Navigator.of(context).maybePop(),
        onDone: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeDashboard, (route) => false),
      ),
    );
  }
}
