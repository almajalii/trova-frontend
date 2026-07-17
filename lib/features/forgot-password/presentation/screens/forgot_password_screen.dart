import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/forgot-password/logic/forgot_password_service.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_bloc.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_event.dart';
import 'package:trova/features/forgot-password/presentation/bloc/forgot_password_state.dart';
import 'package:trova/features/forgot-password/presentation/screens/check_email_screen.dart';
import 'package:trova/features/forgot-password/presentation/widget/forgot_password_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            if (state is ForgotPasswordEmailSent) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckEmailScreen(email: _emailController.text),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ForgotPasswordLoading;

            return ForgotPasswordLayout(
              formKey: _formKey,
              emailController: _emailController,
              isLoading: isLoading,
              onBack: () => Navigator.pop(context),
              onLoginTap: () => Navigator.pop(context),
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordEmailSubmitted(email: _emailController.text),
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
