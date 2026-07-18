import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/guarantees/logic/guarantee_service.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_event.dart';
import 'package:trova/features/guarantees/presentation/bloc/guarantee_state.dart';

class GuaranteeBloc extends Bloc<GuaranteeEvent, GuaranteeState> {
  final GuaranteeService guaranteeService;

  GuaranteeBloc({required this.guaranteeService}) : super(const GuaranteeInitial()) {
    on<GuaranteeRequested>((event, emit) async {
      emit(const GuaranteeLoading());
      try {
        final guarantee = await guaranteeService.requestGuarantee(
          projectId: event.projectId,
          amountJod: event.amountJod,
          type: event.type,
        );
        emit(GuaranteeSuccess(guarantee: guarantee));
      } catch (e) {
        emit(GuaranteeError(message: e.toString()));
      }
    });
  }
}
