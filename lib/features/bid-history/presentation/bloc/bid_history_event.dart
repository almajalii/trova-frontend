import 'package:equatable/equatable.dart';

abstract class BidHistoryEvent extends Equatable {
  const BidHistoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchBidHistory extends BidHistoryEvent {
  const FetchBidHistory();
}
