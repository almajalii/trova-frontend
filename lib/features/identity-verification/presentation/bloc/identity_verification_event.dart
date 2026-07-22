import 'package:equatable/equatable.dart';

abstract class IdentityVerificationEvent extends Equatable {
  const IdentityVerificationEvent();
  @override
  List<Object?> get props => [];
}

class SanadVerificationRequested extends IdentityVerificationEvent {
  final String fullName;
  const SanadVerificationRequested({required this.fullName});

  @override
  List<Object?> get props => [fullName];
}
