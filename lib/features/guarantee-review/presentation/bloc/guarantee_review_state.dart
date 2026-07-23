import 'package:equatable/equatable.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';

abstract class GuaranteeReviewState extends Equatable {
  const GuaranteeReviewState();
  @override
  List<Object?> get props => [];
}

class GuaranteeReviewInitial extends GuaranteeReviewState {
  const GuaranteeReviewInitial();
}

class GuaranteeReviewLoading extends GuaranteeReviewState {
  const GuaranteeReviewLoading();
}

class GuaranteeReviewLoaded extends GuaranteeReviewState {
  final OwnerGuarantee guarantee;
  const GuaranteeReviewLoaded({required this.guarantee});

  @override
  List<Object?> get props => [guarantee];
}

/// Approve/Reject tapped — guarantee stays visible, buttons show a
/// spinner/disabled state instead of replacing the whole screen with a
/// full-page loader.
class GuaranteeReviewSubmitting extends GuaranteeReviewState {
  final OwnerGuarantee guarantee;
  const GuaranteeReviewSubmitting({required this.guarantee});

  @override
  List<Object?> get props => [guarantee];
}

class GuaranteeConfirmed extends GuaranteeReviewState {
  final OwnerGuarantee guarantee;
  const GuaranteeConfirmed({required this.guarantee});

  @override
  List<Object?> get props => [guarantee];
}

class GuaranteeRejected extends GuaranteeReviewState {
  final OwnerGuarantee guarantee;
  const GuaranteeRejected({required this.guarantee});

  @override
  List<Object?> get props => [guarantee];
}

class GuaranteeReviewError extends GuaranteeReviewState {
  final String message;
  const GuaranteeReviewError({required this.message});

  @override
  List<Object?> get props => [message];
}
