import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/capability-score/presentation/bloc/capability_score_event.dart';
import 'package:trova/features/capability-score/presentation/bloc/capability_score_state.dart';

class CapabilityScoreBloc extends Bloc<CapabilityScoreEvent, CapabilityScoreState> {
  final CapabilityScoreService capabilityScoreService;

  CapabilityScoreBloc({required this.capabilityScoreService}) : super(const CapabilityScoreInitial()) {
    on<CapabilityScoreStarted>((event, emit) async {
      emit(const CapabilityScoreLoading());
      try {
        final score = await capabilityScoreService.fetchMyScore();
        emit(CapabilityScoreLoaded(score: score));
      } on ApiException catch (e) {
        if (e.isNotFound) {
          emit(const CapabilityScoreNotFound());
        } else {
          emit(CapabilityScoreError(message: e.message));
        }
      } catch (e) {
        emit(CapabilityScoreError(message: e.toString()));
      }
    });
  }
}
