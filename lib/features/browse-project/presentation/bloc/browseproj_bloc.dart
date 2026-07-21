import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';
import 'package:trova/features/browse-project/logic/browseproj_service.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_event.dart';
import 'package:trova/features/browse-project/presentation/bloc/browseproj_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final ProjectsService service;

  ProjectsBloc({required this.service}) : super(const ProjectsInitial()) {
    on<FetchProjects>(_onFetchProjects);
    on<ApplyFilters>(_onApplyFilters);
  }

  ProjectsFilter get _currentFilter {
    final s = state;
    if (s is ProjectsSuccess) return s.filter;
    return const ProjectsFilter();
  }

  Future<void> _onFetchProjects(FetchProjects event, Emitter<ProjectsState> emit) async {
    emit(const ProjectsLoading());

    try {
      final filter = _currentFilter;
      final projects = await service.fetchProjects(filter: filter);
      emit(ProjectsSuccess(projects: projects, filter: filter));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }

  Future<void> _onApplyFilters(ApplyFilters event, Emitter<ProjectsState> emit) async {
    emit(const ProjectsLoading());

    try {
      final projects = await service.fetchProjects(filter: event.filter);
      emit(ProjectsSuccess(projects: projects, filter: event.filter));
    } catch (e) {
      emit(ProjectsError(message: e.toString()));
    }
  }
}