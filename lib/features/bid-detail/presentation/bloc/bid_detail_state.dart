// lib/features/biddetail/presentation/bloc/bid_detail_state.dart

import 'package:equatable/equatable.dart';
import 'package:trova/features/bid-detail/logic/bide_detail_model.dart';

abstract class BidDetailState extends Equatable {
  const BidDetailState();
  @override
  List<Object?> get props => [];
}

class BidDetailInitial extends BidDetailState {
  const BidDetailInitial();
}

class BidDetailLoading extends BidDetailState {
  const BidDetailLoading();
}

class BidDetailSuccess extends BidDetailState {
  final BidDetailModel detail;
  const BidDetailSuccess({required this.detail});
  @override
  List<Object?> get props => [detail];
}

class BidDetailError extends BidDetailState {
  final String message;
  const BidDetailError({required this.message});
  @override
  List<Object?> get props => [message];
}