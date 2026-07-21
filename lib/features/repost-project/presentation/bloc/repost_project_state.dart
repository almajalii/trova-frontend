import 'package:equatable/equatable.dart';
import 'package:trova/features/repost-project/logic/repost_project_model.dart';

abstract class RepostProjectState extends Equatable {
  const RepostProjectState();

  @override
  List<Object?> get props => [];
}

class RepostProjectInitial extends RepostProjectState {
  const RepostProjectInitial();
}

class RepostProjectLoading extends RepostProjectState {
  const RepostProjectLoading();
}

/// Draft loaded and editable. [isSubmitting] drives the button's loading
/// spinner without losing the current field values (kept separate from a
/// standalone "submitting" state so the form stays on screen and doesn't
/// flash back to a loading skeleton).
class RepostProjectLoaded extends RepostProjectState {
  final RepostProjectDraft draft;
  final bool isSubmitting;

  const RepostProjectLoaded(this.draft, {this.isSubmitting = false});

  RepostProjectLoaded copyWith({RepostProjectDraft? draft, bool? isSubmitting}) {
    return RepostProjectLoaded(draft ?? this.draft, isSubmitting: isSubmitting ?? this.isSubmitting);
  }

  @override
  List<Object?> get props => [draft, isSubmitting];
}

/// Repost succeeded — screen should navigate away using [newProjectId].
class RepostProjectSubmitted extends RepostProjectState {
  final String newProjectId;

  const RepostProjectSubmitted(this.newProjectId);

  @override
  List<Object?> get props => [newProjectId];
}

/// Covers both initial-load failure and submit failure; [draft] is carried
/// along when non-null so a submit-time error can re-render the form with
/// the user's edits intact instead of losing them.
class RepostProjectError extends RepostProjectState {
  final String message;
  final RepostProjectDraft? draft;

  const RepostProjectError(this.message, {this.draft});

  @override
  List<Object?> get props => [message, draft];
}