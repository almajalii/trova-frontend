import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();
  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailSubmitted extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordEmailSubmitted({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordResendRequested extends ForgotPasswordEvent {
  final String email;
  const ForgotPasswordResendRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordResetSubmitted extends ForgotPasswordEvent {
  final String token;
  final String newPassword;
  final String confirmPassword;

  const ForgotPasswordResetSubmitted({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [token, newPassword, confirmPassword];
}
