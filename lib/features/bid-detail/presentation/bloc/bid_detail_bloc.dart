// lib/features/biddetail/presentation/bloc/bid_detail_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/bid-detail/logic/bid_detail_service.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_event.dart';
import 'package:trova/features/bid-detail/presentation/bloc/bid_detail_state.dart';


class BidDetailBloc extends Bloc<BidDetailEvent, BidDetailState> {
  final BidDetailService service;

  BidDetailBloc({required this.service}) : super(const BidDetailInitial()) {
    on<FetchBidDetail>(_onFetchBidDetail);
  }

  Future<void> _onFetchBidDetail(FetchBidDetail event, Emitter<BidDetailState> emit) async {
    emit(const BidDetailLoading());
    try {
      final detail = await service.fetchBidDetail(event.id);
      emit(BidDetailSuccess(detail: detail));
    } catch (e) {
      emit(BidDetailError(message: e.toString()));
    }
  }
}