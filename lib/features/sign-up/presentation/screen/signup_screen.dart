import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/email-verification/presentation/screens/verify_email_screen.dart';
import 'package:trova/features/identity-verification/presentation/screens/identity_verification_screen.dart';
import 'package:trova/features/sign-up/logic/signup_service.dart';
import 'package:trova/features/sign-up/presentation/bloc/signup_bloc.dart';
import 'package:trova/features/sign-up/presentation/bloc/signup_event.dart';
import 'package:trova/features/sign-up/presentation/bloc/signup_state.dart';
import 'package:trova/features/sign-up/presentation/widget/signup_layout.dart';
import 'package:trova/core/routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignupBloc(signupService: sl<SignupService>()),
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is SignupSuccess) {
              final navigator = Navigator.of(context);
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (_) => VerifyEmailScreen(
                    email: state.result.user.email,
                    onVerified: () => navigator.pushReplacement(
                      MaterialPageRoute(builder: (_) => const IdentityVerificationScreen()),
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is SignupLoading;

            return SignupLayout(
              formKey: _formKey,
              nameController: _nameController,
              emailController: _emailController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              isLoading: isLoading,
              onBack: () => Navigator.pop(context),
              onLoginTap: () => Navigator.pushNamed(context, AppRoutes.login),
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  context.read<SignupBloc>().add(
                    SignupSubmitted(
                      name: _nameController.text,
                      workEmail: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
