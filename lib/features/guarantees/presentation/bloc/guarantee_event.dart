import 'package:equatable/equatable.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

abstract class GuaranteeEvent extends Equatable {
  const GuaranteeEvent();
  @override
  List<Object?> get props => [];
}

class GuaranteeRequested extends GuaranteeEvent {
  final String projectId;
  final double amountJod;
  final GuaranteeType type;

  const GuaranteeRequested({required this.projectId, required this.amountJod, required this.type});

  @override
  List<Object?> get props => [projectId, amountJod, type];
}
