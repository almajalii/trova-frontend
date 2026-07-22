import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_event.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_state.dart';


class GuaranteeRequestBloc extends Bloc<GuaranteeRequestEvent, GuaranteeRequestState> {
  final GuaranteeService service;
  static const _lastStepIndex = 5; // 6 steps, 0-indexed

  GuaranteeRequestBloc(this.service) : super(const GuaranteeRequestState()) {
    on<GuaranteeStepDataChanged>((event, emit) {
      emit(state.copyWith(model: event.updatedModel));
    });

    on<GuaranteePrefillRequested>((event, emit) async {
      emit(state.copyWith(isPrefilling: true, prefillError: null));
      try {
        final prefillModel = await service.fetchPrefill(event.projectId);
        emit(state.copyWith(model: prefillModel, isPrefilling: false));
      } catch (e) {
        emit(state.copyWith(isPrefilling: false, prefillError: e.toString()));
      }
    });

    on<GuaranteeNextStep>((event, emit) {
      if (state.currentStep < _lastStepIndex) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<GuaranteeBackStep>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<GuaranteeSubmitRequested>((event, emit) async {
      emit(state.copyWith(status: GuaranteeStatus.loading));
      try {
        await service.submitGuaranteeRequest(state.model);
        emit(state.copyWith(status: GuaranteeStatus.success));
      } catch (e) {
        emit(state.copyWith(
          status: GuaranteeStatus.error,
          errorMessage: e.toString(),
        ));
      }
    });
  }
}