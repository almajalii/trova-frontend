import 'package:equatable/equatable.dart';
import 'package:trova/features/project-history/logic/project_history_model.dart';

abstract class ProjectHistoryState extends Equatable {
  const ProjectHistoryState();
  @override
  List<Object?> get props => [];
}

class ProjectHistoryInitial extends ProjectHistoryState {
  const ProjectHistoryInitial();
}

class ProjectHistoryLoading extends ProjectHistoryState {
  const ProjectHistoryLoading();
}

class ProjectHistoryLoaded extends ProjectHistoryState {
  final List<HistoryProjectSummary> projects;
  const ProjectHistoryLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class ProjectHistoryError extends ProjectHistoryState {
  final String message;
  const ProjectHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
