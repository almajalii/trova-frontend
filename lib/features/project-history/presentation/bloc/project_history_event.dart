import 'package:equatable/equatable.dart';

abstract class ProjectHistoryEvent extends Equatable {
  const ProjectHistoryEvent();
  @override
  List<Object?> get props => [];
}

/// Fired on screen init, and again on pull-to-refresh.
class ProjectHistoryLoadRequested extends ProjectHistoryEvent {
  const ProjectHistoryLoadRequested();
}
