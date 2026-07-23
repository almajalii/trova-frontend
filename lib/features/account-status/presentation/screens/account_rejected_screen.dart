import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/core/storage/token_storage.dart';

/// Shown whenever the account's `approvalStatus` is "rejected" — either
/// because a 403 came back with that status (the interceptor redirect) or
/// right after logging back in while rejected.
class AccountRejectedScreen extends StatelessWidget {
  final String? rejectionReason;
  const AccountRejectedScreen({super.key, this.rejectionReason});

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
    final hasReason = rejectionReason != null && rejectionReason!.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontal),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block_rounded, size: 56, color: AppColors.danger),
                const SizedBox(height: 20),
                AppText(
                  text: 'Account Application Rejected',
                  textSize: 20,
                  fontWeight: FontWeight.w700,
                  textColor: colors.onSurface,
                ),
                const SizedBox(height: 8),
                AppText(
                  text: "Your account application was not approved. You won't be able to access Trova with this account.",
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                ),
                if (hasReason) ...[
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Reason',
                          textSize: 12,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.danger,
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          text: rejectionReason!.trim(),
                          textSize: 14,
                          textColor: colors.onSurface,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                TextButton(onPressed: () => _logOut(context), child: const Text('Log Out')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
