import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/post-project/logic/post_project_service.dart';
import 'package:trova/features/post-project/presentation/bloc/post_project_event.dart';
import 'package:trova/features/post-project/presentation/bloc/post_project_state.dart';

class PostProjectBloc extends Bloc<PostProjectEvent, PostProjectState> {
  final PostProjectService postProjectService;

  PostProjectBloc({required this.postProjectService}) : super(const PostProjectInitial()) {
    on<PostProjectSubmitted>((event, emit) async {
      emit(const PostProjectLoading());
      try {
        final projectId = await postProjectService.submitProject(event.draft);
        emit(PostProjectSuccess(projectId: projectId));
      } catch (e) {
        emit(PostProjectError(message: e.toString()));
      }
    });
  }
}
