import 'package:flutter/material.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/features/bank-connection/presentation/widget/bank_connected_layout.dart';

class BankConnectedScreen extends StatelessWidget {
  final String bankName;
  const BankConnectedScreen({super.key, required this.bankName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BankConnectedLayout(
        bankName: bankName,
        onGoToDashboard: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeDashboard, (route) => false),
      ),
    );
  }
}
