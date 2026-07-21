import 'package:equatable/equatable.dart';

abstract class CompanyProfileEvent extends Equatable {
  const CompanyProfileEvent();
  @override
  List<Object?> get props => [];
}

class CompanyProfileRequested extends CompanyProfileEvent {
  const CompanyProfileRequested();
}
