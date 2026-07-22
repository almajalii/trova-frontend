import 'package:equatable/equatable.dart';

abstract class BidsEvent extends Equatable {
  const BidsEvent();
  @override
  List<Object?> get props => [];
}

class FetchBids extends BidsEvent {
  const FetchBids();
}

class ConfirmBid extends BidsEvent {
  final String id;
  const ConfirmBid(this.id);
  @override
  List<Object?> get props => [id];
}

class CancelBid extends BidsEvent {
  final String id;
  const CancelBid(this.id);
  @override
  List<Object?> get props => [id];
}

class ApplyForGuarantee extends BidsEvent {
  final String id;
  const ApplyForGuarantee(this.id);
  @override
  List<Object?> get props => [id];
}

class MarkWorkAsDone extends BidsEvent {
  final String id;
  const MarkWorkAsDone(this.id);
  @override
  List<Object?> get props => [id];
}

class BackOff extends BidsEvent {
  final String id;
  const BackOff(this.id);
  @override
  List<Object?> get props => [id];
}

class ApplyForNewGuarantee extends BidsEvent {
  final String id;
  const ApplyForNewGuarantee(this.id);
  @override
  List<Object?> get props => [id];
}