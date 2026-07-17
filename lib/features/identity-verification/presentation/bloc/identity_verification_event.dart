import 'package:equatable/equatable.dart';

abstract class IdentityVerificationEvent extends Equatable {
  const IdentityVerificationEvent();
  @override
  List<Object?> get props => [];
}

class SanadVerificationRequested extends IdentityVerificationEvent {
  const SanadVerificationRequested();
}
