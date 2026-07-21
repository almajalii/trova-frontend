import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignupSubmitted extends SignupEvent {
  final String firstName;
  final String lastName;
  final String workEmail;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  const SignupSubmitted({
    required this.firstName,
    required this.lastName,
    required this.workEmail,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [firstName, lastName, workEmail, phoneNumber, password, confirmPassword];
}
