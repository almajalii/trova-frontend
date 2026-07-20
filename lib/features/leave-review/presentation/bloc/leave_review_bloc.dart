import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/leave-review/logic/leave_review_service.dart';
import 'package:trova/features/leave-review/presentation/bloc/leave_review_event.dart';
import 'package:trova/features/leave-review/presentation/bloc/leave_review_state.dart';

class LeaveReviewBloc extends Bloc<LeaveReviewEvent, LeaveReviewState> {
  final LeaveReviewService _service;

  LeaveReviewBloc(this._service) : super(const LeaveReviewInitial()) {
    on<LoadReviewContext>(_onLoadReviewContext);
    on<RateCategory>(_onRateCategory);
    on<ReviewCommentChanged>(_onCommentChanged);
    on<SubmitReview>(_onSubmitReview);
  }

  Future<void> _onLoadReviewContext(LoadReviewContext event, Emitter<LeaveReviewState> emit) async {
    emit(const LeaveReviewLoading());
    try {
      final draft = await _service.fetchContext(event.projectId);
      emit(LeaveReviewLoaded(draft));
    } on ApiException catch (e) {
      emit(LeaveReviewError(e.message));
    }
  }

  void _onRateCategory(RateCategory event, Emitter<LeaveReviewState> emit) {
    final state = this.state;
    if (state is LeaveReviewLoaded) {
      emit(state.copyWith(draft: state.draft.withRating(event.category, event.stars)));
    }
  }

  void _onCommentChanged(ReviewCommentChanged event, Emitter<LeaveReviewState> emit) {
    final state = this.state;
    if (state is LeaveReviewLoaded) {
      emit(state.copyWith(draft: state.draft.copyWith(comment: event.comment)));
    }
  }

  Future<void> _onSubmitReview(SubmitReview event, Emitter<LeaveReviewState> emit) async {
    final state = this.state;
    if (state is! LeaveReviewLoaded) return;

    // Guard client-side rather than relying on the button's disabled state
    // alone — keeps the bloc correct even if the UI layer ever forgets to
    // gate the button on draft.isComplete.
    if (!state.draft.isComplete) {
      emit(LeaveReviewError('Please rate every category before submitting.', draft: state.draft));
      return;
    }

    emit(state.copyWith(isSubmitting: true));
    try {
      await _service.submitReview(state.draft);
      emit(const LeaveReviewSubmitted());
    } on ApiException catch (e) {
      emit(LeaveReviewError(e.message, draft: state.draft));
    }
  }
}
