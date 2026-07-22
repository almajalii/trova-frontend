import 'package:equatable/equatable.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

enum GuaranteeStatus { init, loading, success, error }

class GuaranteeRequestState extends Equatable {
  final GuaranteeStatus status;
  final int currentStep;
  final GuaranteeRequestModel model;
  final String? errorMessage;
  final bool isPrefilling;
  final String? prefillError;

  const GuaranteeRequestState({
    this.status = GuaranteeStatus.init,
    this.currentStep = 0,
    this.model = const GuaranteeRequestModel(),
    this.errorMessage,
    this.isPrefilling = true,
    this.prefillError,
  });

  GuaranteeRequestState copyWith({
    GuaranteeStatus? status,
    int? currentStep,
    GuaranteeRequestModel? model,
    String? errorMessage,
    bool? isPrefilling,
    String? prefillError,
  }) {
    return GuaranteeRequestState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
      errorMessage: errorMessage,
      isPrefilling: isPrefilling ?? this.isPrefilling,
      prefillError: prefillError,
    );
  }

  @override
  List<Object?> get props =>
      [status, currentStep, model, errorMessage, isPrefilling, prefillError];
}