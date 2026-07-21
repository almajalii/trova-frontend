import 'package:equatable/equatable.dart';

abstract class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();
  @override
  List<Object?> get props => [];
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