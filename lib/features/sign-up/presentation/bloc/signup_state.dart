import 'package:equatable/equatable.dart';
import 'package:trova/core/models/auth_result.dart';

abstract class SignupState extends Equatable {
  const SignupState();
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {
  const SignupInitial();
}

class SignupLoading extends SignupState {
  const SignupLoading();
}

class SignupSuccess extends SignupState {
  final AuthResult result;
  const SignupSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class SignupError extends SignupState {
  final String message;
  const SignupError({required this.message});

  @override
  List<Object?> get props => [message];
}
