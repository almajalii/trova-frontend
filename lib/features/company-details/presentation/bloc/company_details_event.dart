import 'package:equatable/equatable.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';

abstract class CompanyDetailsEvent extends Equatable {
  const CompanyDetailsEvent();
  @override
  List<Object?> get props => [];
}

class CompanyDetailsSubmitted extends CompanyDetailsEvent {
  final CompanyDetailsDraft draft;
  const CompanyDetailsSubmitted({required this.draft});

  @override
  List<Object?> get props => [draft];
}

/// Triggers the initial GET fetch of the current user's company details.
class CompanyDetailsRequested extends CompanyDetailsEvent {
  const CompanyDetailsRequested();
}
