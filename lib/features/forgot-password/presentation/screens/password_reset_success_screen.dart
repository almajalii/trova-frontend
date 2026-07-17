import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/core/routes.dart';

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                child: Icon(Icons.check, color: colors.primary, size: 40),
              ),

              const SizedBox(height: 32),

              AppTitle(
                title: 'Password Reset',
                size: 24,
                weight: FontWeight.bold,
                titleColor: colors.onSurface,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              AppText(
                text: 'Your password has been successfully updated. You can now sign in with your new password.',
                textSize: 14,
                textColor: colors.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: context.vertical * 2),

              Button(
                text: 'Continue to Sign In',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: double.infinity,
                buttonHeight: context.buttonSizeH,
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
