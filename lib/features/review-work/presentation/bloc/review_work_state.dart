import 'package:equatable/equatable.dart';
import 'package:trova/features/review-work/logic/submitted_work_model.dart';

abstract class ReviewWorkState extends Equatable {
  const ReviewWorkState();
  @override
  List<Object?> get props => [];
}

class ReviewWorkInitial extends ReviewWorkState {
  const ReviewWorkInitial();
}

class ReviewWorkLoading extends ReviewWorkState {
  const ReviewWorkLoading();
}

class ReviewWorkLoaded extends ReviewWorkState {
  final SubmittedWork work;
  const ReviewWorkLoaded({required this.work});

  @override
  List<Object?> get props => [work];
}

/// Confirm/Flag tapped — work stays visible, buttons disable instead of a
/// full-page loader replacing everything.
class ReviewWorkSubmitting extends ReviewWorkState {
  final SubmittedWork work;
  const ReviewWorkSubmitting({required this.work});

  @override
  List<Object?> get props => [work];
}

class WorkConfirmedComplete extends ReviewWorkState {
  final String projectTitle;
  const WorkConfirmedComplete({required this.projectTitle});

  @override
  List<Object?> get props => [projectTitle];
}

class WorkIssueFlagged extends ReviewWorkState {
  const WorkIssueFlagged();
}

class ReviewWorkError extends ReviewWorkState {
  final String message;
  const ReviewWorkError({required this.message});

  @override
  List<Object?> get props => [message];
}
