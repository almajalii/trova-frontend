import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';

class SetNewPasswordLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const SetNewPasswordLayout({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onBack,
    required this.onSubmit,
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
                  title: 'Set New Password',
                  size: 26,
                  weight: FontWeight.bold,
                  titleColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 6),

                AppText(
                  text: 'Create a new password for your account.',
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: context.vertical),

                AppText(
                  text: 'New Password',
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: passwordController,
                  hintText: 'Create a new password',
                  isPassword: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter a password'),
                    FormBuilderValidators.minLength(8, errorText: 'Password must be at least 8 characters'),
                  ]),
                ),

                const SizedBox(height: 20),

                AppText(
                  text: 'Confirm New Password',
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: confirmPasswordController,
                  hintText: 'Re-enter your new password',
                  isPassword: true,
                  validator: (value) => FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please confirm your password'),
                    FormBuilderValidators.equal(
                      passwordController.text,
                      errorText: 'Passwords do not match',
                    ),
                  ])(value),
                ),

                SizedBox(height: context.vertical),

                Button(
                  text: isLoading ? 'Resetting...' : 'Reset Password',
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
      ),
    );
  }
}
