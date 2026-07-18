import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_service.dart';
import 'package:trova/features/bank-connection/presentation/bloc/bank_connection_event.dart';
import 'package:trova/features/bank-connection/presentation/bloc/bank_connection_state.dart';

class BankConnectionBloc extends Bloc<BankConnectionEvent, BankConnectionState> {
  final BankConnectionService bankConnectionService;

  BankConnectionBloc({required this.bankConnectionService}) : super(const BankConnectionInitial()) {
    on<BankConnectionStarted>((event, emit) async {
      emit(const BankConnectionLoading());
      try {
        final banks = await bankConnectionService.fetchAvailableBanks();
        emit(BankConnectionLoaded(banks: banks));
      } catch (e) {
        emit(BankConnectionError(message: e.toString()));
      }
    });
  }
}
