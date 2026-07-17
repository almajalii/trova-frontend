import 'package:equatable/equatable.dart';

abstract class VerifyEmailState extends Equatable {
  const VerifyEmailState();
  @override
  List<Object?> get props => [];
}

class VerifyEmailInitial extends VerifyEmailState {
  const VerifyEmailInitial();
}

class VerifyEmailLoading extends VerifyEmailState {
  const VerifyEmailLoading();
}

class VerifyEmailSuccess extends VerifyEmailState {
  const VerifyEmailSuccess();
}

class VerifyEmailResendSuccess extends VerifyEmailState {
  const VerifyEmailResendSuccess();
}

class VerifyEmailError extends VerifyEmailState {
  final String message;
  const VerifyEmailError({required this.message});

  @override
  List<Object?> get props => [message];
}
