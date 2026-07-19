import 'package:equatable/equatable.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';

abstract class CompanyDetailsState extends Equatable {
  const CompanyDetailsState();
  @override
  List<Object?> get props => [];
}

class CompanyDetailsInitial extends CompanyDetailsState {
  const CompanyDetailsInitial();
}

/// Submitting the form (POST /company-details).
class CompanyDetailsLoading extends CompanyDetailsState {
  const CompanyDetailsLoading();
}

class CompanyDetailsSuccess extends CompanyDetailsState {
  final String classificationLabel;
  const CompanyDetailsSuccess({required this.classificationLabel});

  @override
  List<Object?> get props => [classificationLabel];
}

class CompanyDetailsError extends CompanyDetailsState {
  final String message;
  const CompanyDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Fetching the current user's company details (GET /company-details).
class CompanyDetailsFetchLoading extends CompanyDetailsState {
  const CompanyDetailsFetchLoading();
}

class CompanyDetailsFetched extends CompanyDetailsState {
  final CompanyDetailsRecord record;
  const CompanyDetailsFetched({required this.record});

  @override
  List<Object?> get props => [record];
}

/// The user hasn't submitted company details yet (404) — this is the
/// normal "first time" case, distinct from [CompanyDetailsError].
class CompanyDetailsNotFound extends CompanyDetailsState {
  const CompanyDetailsNotFound();
}
