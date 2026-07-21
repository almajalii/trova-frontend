import 'package:equatable/equatable.dart';

abstract class AwardState extends Equatable {
  const AwardState();
  @override
  List<Object?> get props => [];
}

class AwardInitial extends AwardState {
  const AwardInitial();
}

class AwardLoading extends AwardState {
  const AwardLoading();
}

class AwardSuccess extends AwardState {
  final String awardedCompanyName;
  const AwardSuccess({required this.awardedCompanyName});

  @override
  List<Object?> get props => [awardedCompanyName];
}

class AwardError extends AwardState {
  final String message;
  const AwardError({required this.message});

  @override
  List<Object?> get props => [message];
}
