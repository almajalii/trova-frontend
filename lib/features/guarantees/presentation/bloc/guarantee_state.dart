import 'package:equatable/equatable.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

abstract class GuaranteeState extends Equatable {
  const GuaranteeState();
  @override
  List<Object?> get props => [];
}

class GuaranteeInitial extends GuaranteeState {
  const GuaranteeInitial();
}

class GuaranteeLoading extends GuaranteeState {
  const GuaranteeLoading();
}

class GuaranteeSuccess extends GuaranteeState {
  final Guarantee guarantee;
  const GuaranteeSuccess({required this.guarantee});

  @override
  List<Object?> get props => [guarantee];
}

class GuaranteeError extends GuaranteeState {
  final String message;
  const GuaranteeError({required this.message});

  @override
  List<Object?> get props => [message];
}
