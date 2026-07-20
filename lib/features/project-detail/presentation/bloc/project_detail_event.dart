import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();
  @override
  List<Object?> get props => [];
}

/// Fired on screen init with the project to load, and again on
/// pull-to-refresh with the same id.
class ProjectDetailLoadRequested extends ProjectDetailEvent {
  final String projectId;
  const ProjectDetailLoadRequested({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
