import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/bid-history/logic/bid_history_service.dart';
import 'package:trova/features/bid-history/presentation/bloc/bid_history_event.dart';
import 'package:trova/features/bid-history/presentation/bloc/bid_history_state.dart';

class BidHistoryBloc extends Bloc<BidHistoryEvent, BidHistoryState> {
  final BidHistoryService service;

  BidHistoryBloc({required this.service}) : super(const BidHistoryInitial()) {
    on<FetchBidHistory>(_onFetch);
  }

  Future<void> _onFetch(FetchBidHistory event, Emitter<BidHistoryState> emit) async {
    emit(const BidHistoryLoading());
    try {
      final bids = await service.fetchBidHistory();
      emit(BidHistorySuccess(bids: bids));
    } catch (e) {
      emit(BidHistoryError(message: e.toString()));
    }
  }
}
