import 'package:equatable/equatable.dart';

abstract class ReviewWorkEvent extends Equatable {
  const ReviewWorkEvent();
  @override
  List<Object?> get props => [];
}

class ReviewWorkLoadRequested extends ReviewWorkEvent {
  final String projectId;
  const ReviewWorkLoadRequested({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

/// Confirms whatever submitted work is currently loaded — no params needed.
class ConfirmCompleteRequested extends ReviewWorkEvent {
  const ConfirmCompleteRequested();
}

/// Flags whatever submitted work is currently loaded.
class FlagIssueRequested extends ReviewWorkEvent {
  const FlagIssueRequested();
}
