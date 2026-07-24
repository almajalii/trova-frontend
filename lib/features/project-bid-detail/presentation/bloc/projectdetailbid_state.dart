import 'package:equatable/equatable.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';

abstract class ProjectDetailState extends Equatable {
  const ProjectDetailState();
  @override
  List<Object?> get props => [];
}

class ProjectDetailInitial extends ProjectDetailState {
  const ProjectDetailInitial();
}

class ProjectDetailLoading extends ProjectDetailState {
  const ProjectDetailLoading();
}

class ProjectDetailSuccess extends ProjectDetailState {
  final Project project;

  /// The contractor's own capability score, used to proactively grey out
  /// "Submit Bid" when it doesn't meet the project's minimum. Null when the
  /// score couldn't be fetched (e.g. no bank connected yet) — treated as
  /// "unknown" rather than "ineligible" so a fetch hiccup never blocks a bid
  /// the backend would otherwise accept; the backend's 400 is still the
  /// final word either way.
  final CapabilityScore? myScore;

  const ProjectDetailSuccess({required this.project, this.myScore});

  @override
  List<Object?> get props => [project, myScore];
}

class ProjectDetailSubmitting extends ProjectDetailState {
  final Project project;
  const ProjectDetailSubmitting({required this.project});

  @override
  List<Object?> get props => [project];
}

class ProjectDetailSubmitted extends ProjectDetailState {
  const ProjectDetailSubmitted();
}

class ProjectDetailError extends ProjectDetailState {
  final String message;
  const ProjectDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// A failed submit attempt (e.g. the backend rejecting a bid that doesn't
/// meet the minimum score/classification). Distinct from [ProjectDetailError]
/// — that state blanks the whole screen (used for page-load failures), which
/// would otherwise wipe the form and the contractor's typed bid amount on a
/// simple validation rejection. This keeps the form on screen; the layout's
/// listener surfaces [message] via a SnackBar instead.
class ProjectDetailSubmitError extends ProjectDetailState {
  final Project project;
  final String message;
  const ProjectDetailSubmitError({required this.project, required this.message});

  @override
  List<Object?> get props => [project, message];
}