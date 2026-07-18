import 'package:equatable/equatable.dart';

abstract class CapabilityScoreEvent extends Equatable {
  const CapabilityScoreEvent();
  @override
  List<Object?> get props => [];
}

class CapabilityScoreStarted extends CapabilityScoreEvent {
  const CapabilityScoreStarted();
}
