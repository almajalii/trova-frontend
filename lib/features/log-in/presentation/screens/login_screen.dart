import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/log-in/logic/login_service.dart';
import 'package:trova/features/log-in/presentation/bloc/login_bloc.dart';
import 'package:trova/features/log-in/presentation/bloc/login_event.dart';
import 'package:trova/features/log-in/presentation/bloc/login_state.dart';
import 'package:trova/features/log-in/presentation/widget/login_layout.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => LoginBloc(loginService: LoginService()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is LoginSuccess) {
              Navigator.pop(context); // placeholder — swap for real navigation later
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;

            return LoginLayout(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              isLoading: isLoading,
              onBack: () => Navigator.pop(context),
              onSignupTap: () => Navigator.pop(context),
              onForgotPasswordTap: () {
                // placeholder — wire real forgot-password flow later
              },
              onBiometricTap: () {
                // placeholder — wire real biometric auth later
              },
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(
                        LoginSubmitted(
                          email: _emailController.text,
                          password: _passwordController.text,
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