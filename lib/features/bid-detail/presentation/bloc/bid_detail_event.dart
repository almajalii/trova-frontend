// lib/features/biddetail/presentation/bloc/bid_detail_event.dart

import 'package:equatable/equatable.dart';

abstract class BidDetailEvent extends Equatable {
  const BidDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchBidDetail extends BidDetailEvent {
  final String id;
  const FetchBidDetail(this.id);
  @override
  List<Object?> get props => [id];
}