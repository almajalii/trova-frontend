import 'package:equatable/equatable.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

abstract class BankConnectionState extends Equatable {
  const BankConnectionState();
  @override
  List<Object?> get props => [];
}

class BankConnectionInitial extends BankConnectionState {
  const BankConnectionInitial();
}

class BankConnectionLoading extends BankConnectionState {
  const BankConnectionLoading();
}

class BankConnectionLoaded extends BankConnectionState {
  final List<BankOption> banks;
  const BankConnectionLoaded({required this.banks});

  @override
  List<Object?> get props => [banks];
}

class BankConnectionError extends BankConnectionState {
  final String message;
  const BankConnectionError({required this.message});

  @override
  List<Object?> get props => [message];
}
