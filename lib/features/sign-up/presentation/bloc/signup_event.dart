import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String workEmail;
  final String password;
  final String confirmPassword;

  const SignupSubmitted({
    required this.name,
    required this.workEmail,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [name, workEmail, password, confirmPassword];
}
