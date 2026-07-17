import 'package:equatable/equatable.dart';

abstract class VerifyEmailEvent extends Equatable {
  const VerifyEmailEvent();
  @override
  List<Object?> get props => [];
}

class VerifyEmailCodeSubmitted extends VerifyEmailEvent {
  final String code;
  const VerifyEmailCodeSubmitted({required this.code});

  @override
  List<Object?> get props => [code];
}

class VerifyEmailResendRequested extends VerifyEmailEvent {
  const VerifyEmailResendRequested();
}
