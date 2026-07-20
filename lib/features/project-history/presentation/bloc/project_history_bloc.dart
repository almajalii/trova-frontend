import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/project-history/logic/project_history_service.dart';
import 'package:trova/features/project-history/presentation/bloc/project_history_event.dart';
import 'package:trova/features/project-history/presentation/bloc/project_history_state.dart';

class ProjectHistoryBloc extends Bloc<ProjectHistoryEvent, ProjectHistoryState> {
  final ProjectHistoryService projectHistoryService;

  ProjectHistoryBloc({required this.projectHistoryService}) : super(const ProjectHistoryInitial()) {
    on<ProjectHistoryLoadRequested>((event, emit) async {
      emit(const ProjectHistoryLoading());
      try {
        final projects = await projectHistoryService.fetchProjectHistory();
        emit(ProjectHistoryLoaded(projects: projects));
      } catch (e) {
        emit(ProjectHistoryError(message: e.toString()));
      }
    });
  }
}
