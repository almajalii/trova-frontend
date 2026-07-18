import 'package:equatable/equatable.dart';

abstract class BankConnectionEvent extends Equatable {
  const BankConnectionEvent();
  @override
  List<Object?> get props => [];
}

class BankConnectionStarted extends BankConnectionEvent {
  const BankConnectionStarted();
}
