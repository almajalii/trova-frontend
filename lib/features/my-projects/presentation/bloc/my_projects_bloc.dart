import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/my-projects/logic/my_projects_service.dart';
import 'package:trova/features/my-projects/presentation/bloc/my_projects_event.dart';
import 'package:trova/features/my-projects/presentation/bloc/my_projects_state.dart';

class MyProjectsBloc extends Bloc<MyProjectsEvent, MyProjectsState> {
  final MyProjectsService myProjectsService;

  MyProjectsBloc({required this.myProjectsService}) : super(const MyProjectsInitial()) {
    on<MyProjectsLoadRequested>((event, emit) async {
      emit(const MyProjectsLoading());
      try {
        final projects = await myProjectsService.fetchMyProjects();
        emit(MyProjectsLoaded(projects: projects));
      } catch (e) {
        emit(MyProjectsError(message: e.toString()));
      }
    });
  }
}
