import 'package:equatable/equatable.dart';
import 'package:trova/features/bid-history/logic/bid_history_model.dart';

abstract class BidHistoryState extends Equatable {
  const BidHistoryState();
  @override
  List<Object?> get props => [];
}

class BidHistoryInitial extends BidHistoryState {
  const BidHistoryInitial();
}

class BidHistoryLoading extends BidHistoryState {
  const BidHistoryLoading();
}

class BidHistorySuccess extends BidHistoryState {
  final List<BidHistoryModel> bids;
  const BidHistorySuccess({required this.bids});
  @override
  List<Object?> get props => [bids];
}

class BidHistoryError extends BidHistoryState {
  final String message;
  const BidHistoryError({required this.message});
  @override
  List<Object?> get props => [message];
}
