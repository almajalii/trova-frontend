import 'package:flutter/material.dart';
import 'package:trova/features/email-verification/presentation/screens/verify_email_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/forgot_password_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/check_email_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/set_new_password_screen.dart';
import 'package:trova/features/forgot-password/presentation/screens/password_reset_success_screen.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';
import 'package:trova/features/identity-verification/presentation/screens/identity_verification_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/sanad_verified_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/scan_id_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/scan_verified_screen.dart';

const _dummyEmail = 'ahmad.khalil@email.com';
const _dummyIdentity = IdentityInfo(
  fullName: 'Ahmad Khalil Al-Rawi',
  nationalId: '9984512345',
);

class ScreensGallery extends StatelessWidget {
  const ScreensGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = <(String, WidgetBuilder)>[
      ('Verify Your Email', (_) => const VerifyEmailScreen(email: _dummyEmail)),
      ('Forgot Password', (_) => const ForgotPasswordScreen()),
      ('Check Your Email (OTP)', (_) => const CheckEmailScreen(email: _dummyEmail)),
      ('Set New Password', (_) => const SetNewPasswordScreen(token: '123456')),
      ('Password Reset Success', (_) => const PasswordResetSuccessScreen()),
      ('Identity Verification (chooser)', (_) => const IdentityVerificationScreen()),
      ('Sanad Verified', (_) => const SanadVerifiedScreen(info: _dummyIdentity)),
      ('Scan National ID', (_) => const ScanIdScreen()),
      ('Scan Verified', (_) => const ScanVerifiedScreen(info: _dummyIdentity)),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Screens gallery (dev only)')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final (label, builder) = entries[index];
          return ListTile(
            title: Text(label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: builder)),
          );
        },
      ),
    );
  }
}
