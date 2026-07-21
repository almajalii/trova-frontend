import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';

class SettingsLayout extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onChangePassword;
  final bool pushNotificationsEnabled;
  final ValueChanged<bool> onPushNotificationsChanged;
  final VoidCallback onLanguage;
  final VoidCallback onHelpAndSupport;
  final VoidCallback onAboutTrova;
  final VoidCallback onLogOut;
  final VoidCallback onDeleteAccount;

  const SettingsLayout({
    super.key,
    required this.onBack,
    required this.onChangePassword,
    required this.pushNotificationsEnabled,
    required this.onPushNotificationsChanged,
    required this.onLanguage,
    required this.onHelpAndSupport,
    required this.onAboutTrova,
    required this.onLogOut,
    required this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 24),
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 8),
          AppTitle(title: 'Settings', size: 24, weight: FontWeight.w700, titleColor: colors.onSurface, textAlign: TextAlign.start),
          const SizedBox(height: 20),

          _SectionLabel('Account'),
          _SettingsRow(label: 'Change Password', onTap: onChangePassword),
          const SizedBox(height: 20),

          _SectionLabel('Preferences'),
          _SettingsRow(
            label: 'Push Notifications',
            trailing: Switch(
              value: pushNotificationsEnabled,
              onChanged: onPushNotificationsChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: colors.primary,
            ),
          ),
          const SizedBox(height: 10),
          _SettingsRow(label: 'Language', valueText: 'English', onTap: onLanguage),
          const SizedBox(height: 20),

          _SectionLabel('Support'),
          _SettingsRow(label: 'Help & Support', onTap: onHelpAndSupport),
          const SizedBox(height: 10),
          _SettingsRow(label: 'About Trova', onTap: onAboutTrova),
          const SizedBox(height: 36),

          Button(
            text: 'Log Out',
            buttonColor: Colors.transparent,
            borderColor: colors.primary,
            textColor: colors.primary,
            borderRadius: 12,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            elevation: 0,
            buttonWidth: double.infinity,
            buttonHeight: context.buttonSizeH,
            onPressed: onLogOut,
          ),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: onDeleteAccount,
              child: AppText(text: 'Delete Account', textSize: 13, fontWeight: FontWeight.w600, textColor: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppText(text: text, textSize: 13, fontWeight: FontWeight.w600, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String label;
  final String? valueText;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsRow({required this.label, this.valueText, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(text: label, textSize: 14, fontWeight: FontWeight.w500, textColor: colors.onSurface, textAlign: TextAlign.start),
            if (trailing != null)
              trailing!
            else
              Row(
                children: [
                  if (valueText != null) ...[
                    AppText(text: valueText!, textSize: 13, textColor: colors.onSurfaceVariant),
                    const SizedBox(width: 4),
                  ],
                  Icon(Icons.chevron_right, color: colors.onSurfaceVariant, size: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
