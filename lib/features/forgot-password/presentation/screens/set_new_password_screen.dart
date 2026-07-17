import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/forgot-password/logic/forgot_password_service.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_bloc.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_event.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_state.dart';
import 'package:trova/features/forgot-password/presentation/screens/password_reset_success_screen.dart';
import 'package:trova/features/forgot-password/presentation/widget/set_new_password_layout.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String token; // the OTP code captured on the previous screen
  const SetNewPasswordScreen({super.key, required this.token});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ForgotPasswordBloc(forgotPasswordService: sl<ForgotPasswordService>()),
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is ForgotPasswordResetSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const PasswordResetSuccessScreen()),
                (route) => route.isFirst, // clear the reset flow off the back stack
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ForgotPasswordLoading;

            return SetNewPasswordLayout(
              formKey: _formKey,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              isLoading: isLoading,
              onBack: () => Navigator.pop(context),
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordResetSubmitted(
                          token: widget.token,
                          newPassword: _passwordController.text,
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
