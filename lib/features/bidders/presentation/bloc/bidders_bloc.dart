import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/bidders/logic/bidders_service.dart';
import 'package:trova/features/bidders/presentation/bloc/bidders_event.dart';
import 'package:trova/features/bidders/presentation/bloc/bidders_state.dart';

class BiddersBloc extends Bloc<BiddersEvent, BiddersState> {
  final BiddersService biddersService;

  BiddersBloc({required this.biddersService}) : super(const BiddersInitial()) {
    on<BiddersStarted>((event, emit) async {
      emit(const BiddersLoading());
      try {
        final bidders = await biddersService.fetchBidders(event.projectId);
        emit(BiddersLoaded(bidders: bidders));
      } catch (e) {
        emit(BiddersError(message: e.toString()));
      }
    });
  }
}
