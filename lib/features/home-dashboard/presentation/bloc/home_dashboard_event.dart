import 'package:equatable/equatable.dart';

abstract class HomeDashboardEvent extends Equatable {
  const HomeDashboardEvent();
  @override
  List<Object?> get props => [];
}

class HomeDashboardStarted extends HomeDashboardEvent {
  const HomeDashboardStarted();
}
