import 'package:equatable/equatable.dart';
import 'package:trova/features/mybids/logic/mybid_model.dart';

abstract class BidsState extends Equatable {
  const BidsState();
  @override
  List<Object?> get props => [];
}

class BidsInitial extends BidsState {
  const BidsInitial();
}

class BidsLoading extends BidsState {
  const BidsLoading();
}

class BidsSuccess extends BidsState {
  final List<BidModel> bids;
  const BidsSuccess({required this.bids});

  @override
  List<Object?> get props => [bids];
}

class BidsError extends BidsState {
  final String message;
  const BidsError({required this.message});

  @override
  List<Object?> get props => [message];
}