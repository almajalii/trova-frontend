import 'package:equatable/equatable.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';

abstract class IdentityVerificationState extends Equatable {
  const IdentityVerificationState();
  @override
  List<Object?> get props => [];
}

class IdentityVerificationInitial extends IdentityVerificationState {
  const IdentityVerificationInitial();
}

class IdentityVerificationLoading extends IdentityVerificationState {
  const IdentityVerificationLoading();
}

class SanadVerificationSuccess extends IdentityVerificationState {
  final IdentityInfo info;
  const SanadVerificationSuccess({required this.info});

  @override
  List<Object?> get props => [info];
}

class IdentityVerificationError extends IdentityVerificationState {
  final String message;
  const IdentityVerificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
