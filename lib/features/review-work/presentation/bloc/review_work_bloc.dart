import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/review-work/logic/review_work_service.dart';
import 'package:trova/features/review-work/presentation/bloc/review_work_event.dart';
import 'package:trova/features/review-work/presentation/bloc/review_work_state.dart';

class ReviewWorkBloc extends Bloc<ReviewWorkEvent, ReviewWorkState> {
  final ReviewWorkService reviewWorkService;

  ReviewWorkBloc({required this.reviewWorkService}) : super(const ReviewWorkInitial()) {
    on<ReviewWorkLoadRequested>((event, emit) async {
      emit(const ReviewWorkLoading());
      try {
        final work = await reviewWorkService.fetchSubmittedWork(event.projectId);
        emit(ReviewWorkLoaded(work: work));
      } catch (e) {
        emit(ReviewWorkError(message: e.toString()));
      }
    });

    on<ConfirmCompleteRequested>((event, emit) async {
      final current = state;
      if (current is! ReviewWorkLoaded) return;
      emit(ReviewWorkSubmitting(work: current.work));
      try {
        await reviewWorkService.confirmComplete(current.work.projectId);
        emit(WorkConfirmedComplete(projectTitle: current.work.projectTitle));
      } catch (e) {
        emit(ReviewWorkError(message: e.toString()));
      }
    });

    on<FlagIssueRequested>((event, emit) async {
      final current = state;
      if (current is! ReviewWorkLoaded) return;
      emit(ReviewWorkSubmitting(work: current.work));
      try {
        await reviewWorkService.flagIssue(current.work.projectId);
        emit(const WorkIssueFlagged());
      } catch (e) {
        emit(ReviewWorkError(message: e.toString()));
      }
    });
  }
}
