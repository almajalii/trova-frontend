import 'package:equatable/equatable.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';

abstract class CapabilityScoreState extends Equatable {
  const CapabilityScoreState();
  @override
  List<Object?> get props => [];
}

class CapabilityScoreInitial extends CapabilityScoreState {
  const CapabilityScoreInitial();
}

class CapabilityScoreLoading extends CapabilityScoreState {
  const CapabilityScoreLoading();
}

class CapabilityScoreLoaded extends CapabilityScoreState {
  final CapabilityScore score;
  const CapabilityScoreLoaded({required this.score});

  @override
  List<Object?> get props => [score];
}

class CapabilityScoreError extends CapabilityScoreState {
  final String message;
  const CapabilityScoreError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// The user hasn't connected a bank account yet (404) — this is the
/// normal "first time" case, distinct from [CapabilityScoreError].
class CapabilityScoreNotFound extends CapabilityScoreState {
  const CapabilityScoreNotFound();
}
