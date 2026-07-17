import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/forgot-password/logic/forgot_password_service.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_bloc.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_event.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_state.dart';
import 'package:trova/features/forgot-password/presentation/screens/set_new_password_screen.dart';
import 'package:trova/features/forgot-password/presentation/widget/check_email_layout.dart';

class CheckEmailScreen extends StatefulWidget {
  final String email;
  const CheckEmailScreen({super.key, required this.email});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  String _currentCode = '';

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
            if (state is ForgotPasswordResendSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reset code resent.')),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ForgotPasswordLoading;

            return CheckEmailLayout(
              email: widget.email,
              isLoading: isLoading,
              onBack: () => Navigator.pop(context),
              onResend: () => context.read<ForgotPasswordBloc>().add(
                    ForgotPasswordResendRequested(email: widget.email),
                  ),
              onCodeCompleted: (code) => setState(() => _currentCode = code),
              // No separate "verify" API call — the code becomes the reset
              // token, actually validated by the backend on the next screen's
              // /auth/reset-password call.
              onSubmit: _currentCode.length == 6
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SetNewPasswordScreen(token: _currentCode),
                        ),
                      )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
