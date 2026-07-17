import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';

class ForgotPasswordLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;
  final VoidCallback onLoginTap;

  const ForgotPasswordLayout({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onBack,
    required this.onSubmit,
    required this.onLoginTap,
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
                  onPressed: onBack,
                  icon: Icon(Icons.arrow_back, color: colors.onSurface),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),

                const SizedBox(height: 8),

                AppTitle(
                  title: 'Forgot Password?',
                  size: 26,
                  weight: FontWeight.bold,
                  titleColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 6),

                AppText(
                  text: "Enter the email associated with your account and we'll send you a reset link.",
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

                const SizedBox(height: 24),

                Button(
                  text: isLoading ? 'Sending...' : 'Send Reset Link',
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

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Remembered your password? ',
                        textSize: 14,
                        textColor: colors.onSurfaceVariant,
                      ),
                      GestureDetector(
                        onTap: onLoginTap,
                        child: AppText(
                          text: 'Log in',
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
