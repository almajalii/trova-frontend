import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadProjectDetail extends ProjectDetailEvent {
  final String projectId;
  const LoadProjectDetail(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class BidAmountChanged extends ProjectDetailEvent {
  final String bidAmount;
  const BidAmountChanged(this.bidAmount);

  @override
  List<Object?> get props => [bidAmount];
}

class SubmitBidPressed extends ProjectDetailEvent {
  const SubmitBidPressed();
}