import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/mybids/logic/mybid_service.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_event.dart';
import 'package:trova/features/mybids/presentation/bloc/mybids_state.dart';


class BidsBloc extends Bloc<BidsEvent, BidsState> {
  final BidsService service;

  BidsBloc({required this.service}) : super(const BidsInitial()) {
    on<FetchBids>(_onFetchBids);
    on<ConfirmBid>((event, emit) => _runAction(emit, () => service.confirmBid(event.id)));
    on<CancelBid>((event, emit) => _runAction(emit, () => service.cancelBid(event.id)));
    on<ApplyForGuarantee>((event, emit) => _runAction(emit, () => service.applyForGuarantee(event.id)));
    on<MarkWorkAsDone>((event, emit) => _runAction(emit, () => service.markWorkAsDone(event.id)));
    on<BackOff>((event, emit) => _runAction(emit, () => service.backOff(event.id)));
    on<ApplyForNewGuarantee>((event, emit) => _runAction(emit, () => service.applyForNewGuarantee(event.id)));
  }

  Future<void> _onFetchBids(FetchBids event, Emitter<BidsState> emit) async {
    emit(const BidsLoading());
    try {
      final bids = await service.fetchBids();
      emit(BidsSuccess(bids: bids));
    } catch (e) {
      emit(BidsError(message: e.toString()));
    }
  }

  Future<void> _runAction(Emitter<BidsState> emit, Future<List<dynamic>> Function() action) async {
    try {
      final bids = await action();
      emit(BidsSuccess(bids: bids.cast()));
    } catch (e) {
      emit(BidsError(message: e.toString()));
    }
  }
}