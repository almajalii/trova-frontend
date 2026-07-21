import 'package:equatable/equatable.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';

abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();
  @override
  List<Object?> get props => [];
}

class FetchProjects extends ProjectsEvent {
  const FetchProjects();
}

class ApplyFilters extends ProjectsEvent {
  final ProjectsFilter filter;
  const ApplyFilters(this.filter);

  @override
  List<Object?> get props => [filter];
}