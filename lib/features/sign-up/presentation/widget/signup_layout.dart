import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/inputfeild.dart';
import 'package:trova/core/responsive_utils.dart';

class SignupLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isLoading;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final VoidCallback onLoginTap;

  const SignupLayout({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isLoading,
    required this.onSubmit,
    required this.onBack,
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
                  title: 'Create Account',
                  size: 26,
                  weight: FontWeight.bold,
                  titleColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),

                const SizedBox(height: 6),

                AppText(
                  text: 'Sign up to get started with Trova',
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: context.vertical),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'First Name',
                            textSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: colors.onSurface,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 8),
                          InputField(
                            controller: firstNameController,
                            hintText: 'First name',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: 'Required'),
                              FormBuilderValidators.minLength(2, errorText: 'Too short'),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Last Name',
                            textSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: colors.onSurface,
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 8),
                          InputField(
                            controller: lastNameController,
                            hintText: 'Last name',
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(errorText: 'Required'),
                              FormBuilderValidators.minLength(2, errorText: 'Too short'),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

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
                  text: 'Phone Number',
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: phoneController,
                  hintText: '79 123 4567',
                  keyboardType: TextInputType.phone,
                  prefixText: '+962 ',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  validator: (value) {
                    final digits = value?.trim() ?? '';
                    if (digits.isEmpty) return 'Please enter your phone number';
                    if (digits.length != 9) return 'Enter a valid 9-digit phone number';
                    return null;
                  },
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
                  hintText: 'Create a password',
                  isPassword: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter a password'),
                    FormBuilderValidators.minLength(6, errorText: 'Password must be at least 6 characters'),
                  ]),
                ),

                const SizedBox(height: 20),

                AppText(
                  text: 'Confirm Password',
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8),
                InputField(
                  controller: confirmPasswordController,
                  hintText: 'Re-enter your password',
                  isPassword: true,
                  validator: (value) => FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please confirm your password'),
                    FormBuilderValidators.equal(passwordController.text, errorText: 'Passwords do not match'),
                  ])(value),
                ),

                SizedBox(height: context.vertical),

                Button(
                  text: isLoading ? 'Signing up...' : 'Sign Up',
                  textColor: colors.onPrimary,
                  borderRadius: 12,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  elevation: 0,
                  buttonWidth: double.infinity,
                  buttonHeight: context.buttonSizeH,
                  onPressed: isLoading ? null : onSubmit,
                ),

                const SizedBox(height: 12),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(text: 'Already have an account? ', textSize: 14, textColor: colors.onSurfaceVariant),
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
