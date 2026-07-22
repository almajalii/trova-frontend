import 'package:equatable/equatable.dart';
import 'package:trova/features/company-profile/logic/company_profile_model.dart';

abstract class CompanyProfileState extends Equatable {
  const CompanyProfileState();
  @override
  List<Object?> get props => [];
}

class CompanyProfileInitial extends CompanyProfileState {
  const CompanyProfileInitial();
}

class CompanyProfileLoading extends CompanyProfileState {
  const CompanyProfileLoading();
}

class CompanyProfileLoaded extends CompanyProfileState {
  final CompanyProfile profile;
  const CompanyProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// The user hasn't submitted Company Details yet (404) — distinct from
/// [CompanyProfileError] so the screen can prompt them to complete it
/// instead of showing a generic error.
class CompanyProfileNotFound extends CompanyProfileState {
  const CompanyProfileNotFound();
}

class CompanyProfileError extends CompanyProfileState {
  final String message;
  const CompanyProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
