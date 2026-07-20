import 'package:equatable/equatable.dart';
import 'package:trova/features/leave-review/logic/leave_review_model.dart';

abstract class LeaveReviewEvent extends Equatable {
  const LeaveReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on screen init to load contractor/project context for [projectId].
class LoadReviewContext extends LeaveReviewEvent {
  final String projectId;

  const LoadReviewContext(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

/// Fired when a star is tapped for [category] — [stars] is 1-5.
class RateCategory extends LeaveReviewEvent {
  final ReviewCategory category;
  final int stars;

  const RateCategory(this.category, this.stars);

  @override
  List<Object?> get props => [category, stars];
}

class ReviewCommentChanged extends LeaveReviewEvent {
  final String comment;

  const ReviewCommentChanged(this.comment);

  @override
  List<Object?> get props => [comment];
}

/// Fired when "Submit Review" is tapped.
class SubmitReview extends LeaveReviewEvent {
  const SubmitReview();
}
