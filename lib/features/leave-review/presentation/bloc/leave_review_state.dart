import 'package:equatable/equatable.dart';
import 'package:trova/features/leave-review/logic/leave_review_model.dart';

abstract class LeaveReviewState extends Equatable {
  const LeaveReviewState();

  @override
  List<Object?> get props => [];
}

class LeaveReviewInitial extends LeaveReviewState {
  const LeaveReviewInitial();
}

class LeaveReviewLoading extends LeaveReviewState {
  const LeaveReviewLoading();
}

/// Draft loaded and editable. [isSubmitting] drives the button spinner
/// without swapping the form out for a loading skeleton — same pattern as
/// RepostProjectLoaded.
class LeaveReviewLoaded extends LeaveReviewState {
  final LeaveReviewDraft draft;
  final bool isSubmitting;

  const LeaveReviewLoaded(this.draft, {this.isSubmitting = false});

  LeaveReviewLoaded copyWith({LeaveReviewDraft? draft, bool? isSubmitting}) {
    return LeaveReviewLoaded(draft ?? this.draft, isSubmitting: isSubmitting ?? this.isSubmitting);
  }

  @override
  List<Object?> get props => [draft, isSubmitting];
}

/// Review submitted successfully — screen should navigate away.
class LeaveReviewSubmitted extends LeaveReviewState {
  const LeaveReviewSubmitted();
}

/// Covers both initial-load failure and submit failure; [draft] is carried
/// along when non-null so a submit-time error re-renders the form with the
/// owner's ratings/comment intact instead of losing them.
class LeaveReviewError extends LeaveReviewState {
  final String message;
  final LeaveReviewDraft? draft;

  const LeaveReviewError(this.message, {this.draft});

  @override
  List<Object?> get props => [message, draft];
}
