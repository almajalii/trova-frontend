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

/// Confirms whatever guarantee is currently loaded — no params needed
/// since the bloc already holds it in its Loaded state. Only valid once
/// the bank has issued it (status == ISSUED).
class GuaranteeConfirmRequested extends GuaranteeReviewEvent {
  const GuaranteeConfirmRequested();
}

/// Rejects whatever guarantee is currently loaded. `reason` is an optional
/// note the owner can leave — the backend accepts null/omitted.
class GuaranteeRejectRequested extends GuaranteeReviewEvent {
  final String? reason;
  const GuaranteeRejectRequested({this.reason});

  @override
  List<Object?> get props => [reason];
}
