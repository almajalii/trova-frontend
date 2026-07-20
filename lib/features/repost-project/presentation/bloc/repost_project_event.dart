import 'package:equatable/equatable.dart';

abstract class RepostProjectEvent extends Equatable {
  const RepostProjectEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on screen init to load the prefilled draft for [projectId].
class LoadRepostDraft extends RepostProjectEvent {
  final String projectId;

  const LoadRepostDraft(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class RepostTitleChanged extends RepostProjectEvent {
  final String title;

  const RepostTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class RepostSectorChanged extends RepostProjectEvent {
  final String sector;

  const RepostSectorChanged(this.sector);

  @override
  List<Object?> get props => [sector];
}

class RepostContractValueChanged extends RepostProjectEvent {
  final double contractValueJod;

  const RepostContractValueChanged(this.contractValueJod);

  @override
  List<Object?> get props => [contractValueJod];
}

class RepostMinRequiredScoreChanged extends RepostProjectEvent {
  final int minRequiredScore;

  const RepostMinRequiredScoreChanged(this.minRequiredScore);

  @override
  List<Object?> get props => [minRequiredScore];
}

class RepostMinContractorClassificationChanged extends RepostProjectEvent {
  final String minContractorClassification;

  const RepostMinContractorClassificationChanged(this.minContractorClassification);

  @override
  List<Object?> get props => [minContractorClassification];
}

class RepostDescriptionChanged extends RepostProjectEvent {
  final String description;

  const RepostDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

/// Fired when "Re-post Project" is tapped.
class SubmitRepost extends RepostProjectEvent {
  const SubmitRepost();
}
