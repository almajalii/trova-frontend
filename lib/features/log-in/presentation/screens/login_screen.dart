import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/core/services/biometric_auth_service.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/log-in/logic/biometric_login_service.dart';
import 'package:trova/features/log-in/logic/login_service.dart';
import 'package:trova/features/log-in/presentation/bloc/login_bloc.dart';
import 'package:trova/features/log-in/presentation/bloc/login_event.dart';
import 'package:trova/features/log-in/presentation/bloc/login_state.dart';
import 'package:trova/features/log-in/presentation/widget/login_layout.dart';
import 'package:trova/core/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showBiometricOption = false;
  bool _loggingInWithBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    final tokenStorage = sl<TokenStorage>();

    final supported = await sl<BiometricAuthService>().isDeviceSupported();
    final enabled = await tokenStorage.isBiometricEnabled();
    final token = await tokenStorage.getToken();

    if (!mounted) return;
    setState(() {
      _showBiometricOption = supported && enabled && token != null && token.isNotEmpty;
    });
  }

  Future<void> _maybeOfferBiometricEnrollment(BuildContext context) async {
    final tokenStorage = sl<TokenStorage>();
    final supported = await sl<BiometricAuthService>().isDeviceSupported();
    final alreadyEnabled = await tokenStorage.isBiometricEnabled();

    if (!supported || alreadyEnabled || !context.mounted) return;

    final enable = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enable Face ID / Touch ID login?'),
        content: const Text('Sign in faster next time using your device biometrics.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (enable == true) {
      await tokenStorage.setBiometricEnabled(true);
    }
  }

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
        create: (_) => LoginBloc(
          loginService: sl<LoginService>(),
          biometricLoginService: sl<BiometricLoginService>(),
        ),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is LoginSuccess) {
              if (!_loggingInWithBiometrics) {
                await _maybeOfferBiometricEnrollment(context);
              }
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.homeDashboard,
                  (route) => false,
                );
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;

            return LoginLayout(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              isLoading: isLoading,
              showBiometricOption: _showBiometricOption,
              onBack: () => Navigator.pop(context),
              onSignupTap: () => Navigator.pushNamed(context, AppRoutes.signup),
              onForgotPasswordTap: () {
                Navigator.pushNamed(context, AppRoutes.forgotPassword);
              },
              onBiometricTap: () {
                _loggingInWithBiometrics = true;
                context.read<LoginBloc>().add(const BiometricLoginRequested());
              },
              onSubmit: () {
                if (_formKey.currentState!.validate()) {
                  _loggingInWithBiometrics = false;
                  context.read<LoginBloc>().add(
                    LoginSubmitted(email: _emailController.text, password: _passwordController.text),
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
