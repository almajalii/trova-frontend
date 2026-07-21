import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/settings/presentation/screens/about_trova_screen.dart';
import 'package:trova/features/settings/presentation/screens/change_password_screen.dart';
import 'package:trova/features/settings/presentation/widget/settings_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPushNotificationsPref();
  }

  Future<void> _loadPushNotificationsPref() async {
    final enabled = await sl<TokenStorage>().isPushNotificationsEnabled();
    if (mounted) setState(() => _pushNotificationsEnabled = enabled);
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$feature is coming soon')));
  }

  Future<void> _confirmLogOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text("You'll need to log in again to access your account."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Log Out', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final tokenStorage = sl<TokenStorage>();
    await tokenStorage.clearToken();
    await tokenStorage.setBiometricEnabled(false);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  Future<void> _confirmDeleteAccount() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          "Account deletion isn't available yet. Contact support if you'd like your account removed.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsLayout(
        onBack: () => Navigator.of(context).maybePop(),
        onChangePassword: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
        pushNotificationsEnabled: _pushNotificationsEnabled,
        onPushNotificationsChanged: (enabled) {
          setState(() => _pushNotificationsEnabled = enabled);
          sl<TokenStorage>().setPushNotificationsEnabled(enabled);
        },
        onLanguage: () => _showComingSoon('Language selection'),
        onHelpAndSupport: () => _showComingSoon('Help & Support'),
        onAboutTrova: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutTrovaScreen())),
        onLogOut: _confirmLogOut,
        onDeleteAccount: _confirmDeleteAccount,
      ),
    );
  }
}
