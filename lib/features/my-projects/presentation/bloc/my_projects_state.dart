import 'package:equatable/equatable.dart';
import 'package:trova/features/my-projects/logic/my_projects_model.dart';

abstract class MyProjectsState extends Equatable {
  const MyProjectsState();
  @override
  List<Object?> get props => [];
}

class MyProjectsInitial extends MyProjectsState {
  const MyProjectsInitial();
}

class MyProjectsLoading extends MyProjectsState {
  const MyProjectsLoading();
}

class MyProjectsLoaded extends MyProjectsState {
  final List<ProjectSummary> projects;
  const MyProjectsLoaded({required this.projects});

  @override
  List<Object?> get props => [projects];
}

class MyProjectsError extends MyProjectsState {
  final String message;
  const MyProjectsError({required this.message});

  @override
  List<Object?> get props => [message];
}
