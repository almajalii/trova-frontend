import 'package:equatable/equatable.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

abstract class GuaranteeRequestEvent extends Equatable {
  const GuaranteeRequestEvent();
  @override
  List<Object?> get props => [];
}

class GuaranteeStepDataChanged extends GuaranteeRequestEvent {
  final GuaranteeRequestModel updatedModel;
  const GuaranteeStepDataChanged(this.updatedModel);
  @override
  List<Object?> get props => [updatedModel];
}

class GuaranteePrefillRequested extends GuaranteeRequestEvent {
  final String projectId;
  const GuaranteePrefillRequested(this.projectId);
  @override
  List<Object?> get props => [projectId];
}

class GuaranteeNextStep extends GuaranteeRequestEvent {}

class GuaranteeBackStep extends GuaranteeRequestEvent {}

class GuaranteeSubmitRequested extends GuaranteeRequestEvent {}