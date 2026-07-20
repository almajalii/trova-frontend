import 'package:equatable/equatable.dart';

abstract class GuaranteeReviewEvent extends Equatable {
  const GuaranteeReviewEvent();
  @override
  List<Object?> get props => [];
}

class GuaranteeReviewLoadRequested extends GuaranteeReviewEvent {
  final String projectId;
  const GuaranteeReviewLoadRequested({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

/// Approves whatever guarantee is currently loaded — no params needed
/// since the bloc already holds it in its Loaded state.
class GuaranteeApproveRequested extends GuaranteeReviewEvent {
  const GuaranteeApproveRequested();
}

/// Rejects whatever guarantee is currently loaded.
class GuaranteeRejectRequested extends GuaranteeReviewEvent {
  const GuaranteeRejectRequested();
}
