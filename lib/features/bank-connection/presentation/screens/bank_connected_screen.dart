import 'package:flutter/material.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/navigation/approval_redirect.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bank-connection/presentation/widget/bank_connected_layout.dart';
import 'package:trova/features/log-in/logic/login_service.dart';

class BankConnectedScreen extends StatelessWidget {
  final String bankName;
  const BankConnectedScreen({super.key, required this.bankName});

  // Accounts start "pending" and most endpoints 403 until an admin approves
  // them, so this can no longer jump straight to the dashboard — it has to
  // re-check the freshly-created account's approvalStatus first.
  Future<void> _goToDashboard(BuildContext context) async {
    try {
      final user = await sl<LoginService>().fetchCurrentUser();
      if (!context.mounted) return;
      await navigateByApprovalStatus(context, user);
    } on ApiException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BankConnectedLayout(bankName: bankName, onGoToDashboard: () => _goToDashboard(context)),
    );
  }
}
