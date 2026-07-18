import 'package:equatable/equatable.dart';

abstract class CompanyDetailsState extends Equatable {
  const CompanyDetailsState();
  @override
  List<Object?> get props => [];
}

class CompanyDetailsInitial extends CompanyDetailsState {
  const CompanyDetailsInitial();
}

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
