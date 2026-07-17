import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

// Email sent successfully — screen listens for this to navigate to
// "Check Your Email"
class ForgotPasswordEmailSent extends ForgotPasswordState {
  const ForgotPasswordEmailSent();
}

class ForgotPasswordResendSuccess extends ForgotPasswordState {
  const ForgotPasswordResendSuccess();
}

// Password actually reset — screen listens for this to navigate to the
// "Password Reset" success screen
class ForgotPasswordResetSuccess extends ForgotPasswordState {
  const ForgotPasswordResetSuccess();
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  const ForgotPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
