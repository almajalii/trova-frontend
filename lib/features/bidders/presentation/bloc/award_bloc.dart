import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/bidders/logic/bidders_service.dart';
import 'package:trova/features/bidders/presentation/bloc/award_event.dart';
import 'package:trova/features/bidders/presentation/bloc/award_state.dart';

class AwardBloc extends Bloc<AwardEvent, AwardState> {
  final BiddersService biddersService;

  AwardBloc({required this.biddersService}) : super(const AwardInitial()) {
    on<AwardRequested>((event, emit) async {
      emit(const AwardLoading());
      try {
        final result = await biddersService.awardBid(event.projectId, event.bidId);
        emit(AwardSuccess(awardedCompanyName: result.awardedCompanyName));
      } catch (e) {
        emit(AwardError(message: e.toString()));
      }
    });
  }
}
