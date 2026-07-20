import 'package:equatable/equatable.dart';
import 'package:trova/features/project-detail/logic/project_detail_model.dart';

abstract class ProjectDetailState extends Equatable {
  const ProjectDetailState();
  @override
  List<Object?> get props => [];
}

class ProjectDetailInitial extends ProjectDetailState {
  const ProjectDetailInitial();
}

class ProjectDetailLoading extends ProjectDetailState {
  const ProjectDetailLoading();
}

class ProjectDetailLoaded extends ProjectDetailState {
  final ProjectDetail project;
  const ProjectDetailLoaded({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectDetailError extends ProjectDetailState {
  final String message;
  const ProjectDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
