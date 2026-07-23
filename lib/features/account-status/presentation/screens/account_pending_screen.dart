import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/navigation/approval_redirect.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/log-in/logic/login_service.dart';

/// Shown whenever the account is still awaiting admin review — either
/// because a 403 came back with `approvalStatus: "pending"` (the interceptor
/// redirect), right after signup finishes, or right after logging back in
/// while still pending.
class AccountPendingScreen extends StatefulWidget {
  const AccountPendingScreen({super.key});

  @override
  State<AccountPendingScreen> createState() => _AccountPendingScreenState();
}

class _AccountPendingScreenState extends State<AccountPendingScreen> {
  bool _checking = false;

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    try {
      final user = await sl<LoginService>().fetchCurrentUser();
      if (!mounted) return;
      if (user.isPending) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Still awaiting approval — check back soon.")));
      } else {
        await navigateByApprovalStatus(context, user);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _logOut(BuildContext context) async {
    final tokenStorage = sl<TokenStorage>();
    await tokenStorage.clearToken();
    await tokenStorage.setBiometricEnabled(false);
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontal),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_top_rounded, size: 56, color: AppColors.warning),
                const SizedBox(height: 20),
                AppText(
                  text: 'Awaiting Admin Approval',
                  textSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: colors.onSurface,
                ),
                const SizedBox(height: 8),
                AppText(
                  text:
                      "Your account is currently under review. We'll email you as soon as a decision is made, "
                      "or you can check back here any time.",
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                ),
                const SizedBox(height: 24),
                Button(
                  text: _checking ? 'Checking...' : 'Check Status',
                  textColor: Colors.white,
                  borderRadius: 10,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  elevation: 0,
                  buttonWidth: double.infinity,
                  buttonHeight: context.buttonSizeH,
                  onPressed: _checking ? null : _checkStatus,
                ),
                const SizedBox(height: 12),
                TextButton(onPressed: () => _logOut(context), child: const Text('Log Out')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
