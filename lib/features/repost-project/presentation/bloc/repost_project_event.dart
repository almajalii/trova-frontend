import 'package:equatable/equatable.dart';
import 'package:trova/features/repost-project/logic/repost_project_model.dart';

abstract class RepostProjectEvent extends Equatable {
  const RepostProjectEvent();

  @override
  List<Object?> get props => [];
}

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
  final ContractorClassification minContractorClassification;
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

class RepostLocationChanged extends RepostProjectEvent {
  final String location;
  const RepostLocationChanged(this.location);

  @override
  List<Object?> get props => [location];
}

class RepostCurrencyChanged extends RepostProjectEvent {
  final String currency;
  const RepostCurrencyChanged(this.currency);

  @override
  List<Object?> get props => [currency];
}

class RepostTimelineChanged extends RepostProjectEvent {
  final String timelineText;
  const RepostTimelineChanged(this.timelineText);

  @override
  List<Object?> get props => [timelineText];
}

class RepostMilestonesChanged extends RepostProjectEvent {
  final String milestones;
  const RepostMilestonesChanged(this.milestones);

  @override
  List<Object?> get props => [milestones];
}

class RepostGuaranteeTypeChanged extends RepostProjectEvent {
  final String guaranteeTypeRequired;
  const RepostGuaranteeTypeChanged(this.guaranteeTypeRequired);

  @override
  List<Object?> get props => [guaranteeTypeRequired];
}

class RepostPaymentTermsChanged extends RepostProjectEvent {
  final String paymentTerms;
  const RepostPaymentTermsChanged(this.paymentTerms);

  @override
  List<Object?> get props => [paymentTerms];
}

class RepostBidDeadlineChanged extends RepostProjectEvent {
  final DateTime bidSubmissionDeadline;
  const RepostBidDeadlineChanged(this.bidSubmissionDeadline);

  @override
  List<Object?> get props => [bidSubmissionDeadline];
}

class SubmitRepost extends RepostProjectEvent {
  const SubmitRepost();
}
