import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/network/api_exception.dart';
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
      } on ApiException catch (e) {
        emit(ReviewWorkError(message: e.message));
      } catch (e) {
        emit(ReviewWorkError(message: 'Something went wrong. Please try again.'));
      }
    });

    on<ConfirmCompleteRequested>((event, emit) async {
      final current = state;
      if (current is! ReviewWorkLoaded) return;
      emit(ReviewWorkSubmitting(work: current.work));
      try {
        await reviewWorkService.confirmComplete(current.work.projectId);
        emit(WorkConfirmedComplete(projectId: current.work.projectId, projectTitle: current.work.projectTitle));
      } on ApiException catch (e) {
        emit(ReviewWorkError(message: e.message));
      } catch (e) {
        emit(ReviewWorkError(message: 'Something went wrong. Please try again.'));
      }
    });

    on<FlagIssueRequested>((event, emit) async {
      final current = state;
      if (current is! ReviewWorkLoaded) return;
      emit(ReviewWorkSubmitting(work: current.work));
      try {
        await reviewWorkService.flagIssue(current.work.projectId, event.reason);
        emit(const WorkIssueFlagged());
      } on ApiException catch (e) {
        emit(ReviewWorkError(message: e.message));
      } catch (e) {
        emit(ReviewWorkError(message: 'Something went wrong. Please try again.'));
      }
    });
  }
}
