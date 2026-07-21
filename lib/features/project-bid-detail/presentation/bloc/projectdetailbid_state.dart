import 'package:equatable/equatable.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';

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

class ProjectDetailSuccess extends ProjectDetailState {
  final Project project;
  const ProjectDetailSuccess({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectDetailSubmitting extends ProjectDetailState {
  final Project project;
  const ProjectDetailSubmitting({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectDetailSubmitted extends ProjectDetailState {
  const ProjectDetailSubmitted();
}

class ProjectDetailError extends ProjectDetailState {
  final String message;
  const ProjectDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}