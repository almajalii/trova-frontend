import 'package:equatable/equatable.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

enum GuaranteeStatus { init, loading, success, error }

class GuaranteeRequestState extends Equatable {
  final GuaranteeStatus status;
  final int currentStep;
  final GuaranteeRequestModel model;
  final String? errorMessage;

  const GuaranteeRequestState({
    this.status = GuaranteeStatus.init,
    this.currentStep = 0,
    this.model = const GuaranteeRequestModel(),
    this.errorMessage,
  });

  GuaranteeRequestState copyWith({
    GuaranteeStatus? status,
    int? currentStep,
    GuaranteeRequestModel? model,
    String? errorMessage,
  }) {
    return GuaranteeRequestState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentStep, model, errorMessage];
}