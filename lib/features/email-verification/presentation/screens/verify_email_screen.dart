import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/email-verification/logic/verify_email_service.dart';
import 'package:trova/features/email-verification/presentation/bloc/verify_email_bloc.dart';
import 'package:trova/features/email-verification/presentation/bloc/verify_email_event.dart';
import 'package:trova/features/email-verification/presentation/bloc/verify_email_state.dart';
import 'package:trova/features/email-verification/presentation/widget/verify_email_layout.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final VoidCallback? onVerified;

  const VerifyEmailScreen({super.key, required this.email, this.onVerified});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String _currentCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => VerifyEmailBloc(verifyEmailService: sl<VerifyEmailService>()),
        child: BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
          listener: (context, state) {
            if (state is VerifyEmailError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is VerifyEmailResendSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification code resent.')),
              );
            }
            if (state is VerifyEmailSuccess) {
              if (widget.onVerified != null) {
                widget.onVerified!();
              } else {
                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is VerifyEmailLoading;

            return VerifyEmailLayout(
              email: widget.email,
              isLoading: isLoading,
              onBack: () => Navigator.pop(context),
              onChangeEmail: () => Navigator.pop(context),
              onResend: () => context.read<VerifyEmailBloc>().add(const VerifyEmailResendRequested()),
              onCodeCompleted: (code) => setState(() => _currentCode = code),
              onSubmit: _currentCode.length == 6
                  ? () => context.read<VerifyEmailBloc>().add(
                        VerifyEmailCodeSubmitted(code: _currentCode),
                      )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
