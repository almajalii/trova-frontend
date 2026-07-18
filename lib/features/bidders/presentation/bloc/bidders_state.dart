import 'package:equatable/equatable.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';

abstract class BiddersState extends Equatable {
  const BiddersState();
  @override
  List<Object?> get props => [];
}

class BiddersInitial extends BiddersState {
  const BiddersInitial();
}

class BiddersLoading extends BiddersState {
  const BiddersLoading();
}

class BiddersLoaded extends BiddersState {
  final List<Bidder> bidders;
  const BiddersLoaded({required this.bidders});

  @override
  List<Object?> get props => [bidders];
}

class BiddersError extends BiddersState {
  final String message;
  const BiddersError({required this.message});

  @override
  List<Object?> get props => [message];
}
