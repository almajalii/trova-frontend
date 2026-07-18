import 'package:equatable/equatable.dart';
import 'package:trova/features/home-dashboard/logic/home_dashboard_model.dart';

abstract class HomeDashboardState extends Equatable {
  const HomeDashboardState();
  @override
  List<Object?> get props => [];
}

class HomeDashboardInitial extends HomeDashboardState {
  const HomeDashboardInitial();
}

class HomeDashboardLoading extends HomeDashboardState {
  const HomeDashboardLoading();
}

class HomeDashboardLoaded extends HomeDashboardState {
  final HomeSummary summary;
  const HomeDashboardLoaded({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class HomeDashboardError extends HomeDashboardState {
  final String message;
  const HomeDashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
