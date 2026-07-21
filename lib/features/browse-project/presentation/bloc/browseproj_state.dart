import 'package:equatable/equatable.dart';
import 'package:trova/features/browse-project/logic/browseproj_model.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';

abstract class ProjectsState extends Equatable {
  const ProjectsState();
  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsSuccess extends ProjectsState {
  final List<ProjectModel> projects;
  final ProjectsFilter filter;
  const ProjectsSuccess({required this.projects, required this.filter});

  @override
  List<Object?> get props => [projects, filter];
}

class ProjectsError extends ProjectsState {
  final String message;
  const ProjectsError({required this.message});

  @override
  List<Object?> get props => [message];
}