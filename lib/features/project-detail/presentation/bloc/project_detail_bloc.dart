import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/project-detail/logic/project_detail_service.dart';
import 'package:trova/features/project-detail/presentation/bloc/project_detail_event.dart';
import 'package:trova/features/project-detail/presentation/bloc/project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ProjectDetailService projectDetailService;

  ProjectDetailBloc({required this.projectDetailService}) : super(const ProjectDetailInitial()) {
    on<ProjectDetailLoadRequested>((event, emit) async {
      emit(const ProjectDetailLoading());
      try {
        final project = await projectDetailService.fetchProjectDetail(event.projectId);
        emit(ProjectDetailLoaded(project: project));
      } catch (e) {
        emit(ProjectDetailError(message: e.toString()));
      }
    });
  }
}
