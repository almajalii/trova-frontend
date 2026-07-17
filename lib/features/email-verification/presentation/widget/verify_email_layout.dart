import 'package:flutter/material.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/otp_input.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyEmailLayout extends StatelessWidget {
  final String email;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onResend;
  final VoidCallback onChangeEmail;
  final void Function(String code) onCodeCompleted;
  final VoidCallback? onSubmit;

  const VerifyEmailLayout({
    super.key,
    required this.email,
    required this.isLoading,
    required this.onBack,
    required this.onResend,
    required this.onChangeEmail,
    required this.onCodeCompleted,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.vertical),

              IconButton(
                onPressed: onBack,
                icon: Icon(Icons.arrow_back, color: colors.onSurface),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              SizedBox(height: context.vertical),

              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                  child: SvgPicture.asset('assets/images/auth/Mail_Badge.svg'),
                ),
              ),

              const SizedBox(height: 32),

              Center(
                child: AppTitle(
                  title: 'Verify Your Email',
                  size: 24,
                  weight: FontWeight.bold,
                  titleColor: colors.onSurface,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              AppText(
                text: 'We sent a verification link to $email. Click the link to activate your account.',
                textSize: 14,
                textColor: colors.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Center(
                child: GestureDetector(
                  onTap: onChangeEmail,
                  child: AppText(
                    text: 'Change email address',
                    textSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: colors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              OtpInput(onCompleted: onCodeCompleted),

              const SizedBox(height: 32),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(text: "Didn't get the email? ", textSize: 14, textColor: colors.onSurfaceVariant),
                    GestureDetector(
                      onTap: isLoading ? null : onResend,
                      child: AppText(
                        text: 'Resend',
                        textSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.vertical),

              Button(
                text: isLoading ? 'Verifying...' : 'Verify Email',
                textColor: colors.onPrimary,
                borderRadius: 12,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: double.infinity,
                buttonHeight: context.buttonSizeH,
                onPressed: isLoading ? null : onSubmit,
              ),

              SizedBox(height: context.vertical),
            ],
          ),
        ),
      ),
    );
  }
}
