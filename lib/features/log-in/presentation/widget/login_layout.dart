import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';

class LoginLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback onSignupTap;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onBiometricTap;
  final bool showBiometricOption;

  const LoginLayout({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onBack,
    required this.onSignupTap,
    required this.onForgotPasswordTap,
    required this.onBiometricTap,
    required this.showBiometricOption,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.vertical),

                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.arrow_back, color: colors.onSurface),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                const SizedBox(height: 8),

                AppTitle(
                  title: 'Welcome Back',
                  size: 26,
                  weight: FontWeight.bold,
                  titleColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 6),

                AppText(
                  text: 'Sign in to your Trova account',
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: context.vertical),

                AppText(
                  text: 'Email',
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter your email'),
                    FormBuilderValidators.email(errorText: 'Enter a valid email'),
                  ]),
                ),

                const SizedBox(height: 20),

                AppText(
                  text: 'Password',
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  isPassword: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter your password'),
                  ]),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onForgotPasswordTap,
                    child: AppText(
                      text: 'Forgot Password?',
                      textSize: 13,
                      fontWeight: FontWeight.w600,
                      textColor: colors.primary,
                    ),
                  ),
                ),

                SizedBox(height: context.vertical),

                Button(
                  text: isLoading ? 'Signing in...' : 'Sign In',
                  textColor: colors.onPrimary,
                  borderRadius: 12,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  elevation: 0,
                  buttonWidth: double.infinity,
                  buttonHeight: context.buttonSizeH,
                  onPressed: isLoading ? null : onSubmit,
                ),

                const SizedBox(height: 16),

                if (showBiometricOption) ...[
                  Row(
                    children: [
                      Expanded(child: Divider(color: colors.surfaceContainerHighest)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AppText(text: 'or', textSize: 13, textColor: colors.onSurfaceVariant),
                      ),
                      Expanded(child: Divider(color: colors.surfaceContainerHighest)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Button(
                    text: 'Sign in with Face ID / Touch ID',
                    buttonColor: colors.surface,
                    textColor: colors.primary,
                    borderColor: colors.primary,
                    borderRadius: 12,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    elevation: 0,
                    buttonWidth: double.infinity,
                    buttonHeight: context.buttonSizeH,
                    svgIconPath: 'assets/images/auth/Scan_Icon.svg',
                    onPressed: onBiometricTap,
                  ),
                ],

                SizedBox(height: context.vertical),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(text: "Don't have an account? ", textSize: 14, textColor: colors.onSurfaceVariant),
                      GestureDetector(
                        onTap: onSignupTap,
                        child: AppText(
                          text: 'Sign Up',
                          textSize: 14,
                          fontWeight: FontWeight.w600,
                          textColor: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.vertical),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
