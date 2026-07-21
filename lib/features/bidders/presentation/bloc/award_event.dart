import 'package:equatable/equatable.dart';

abstract class AwardEvent extends Equatable {
  const AwardEvent();
  @override
  List<Object?> get props => [];
}

class AwardRequested extends AwardEvent {
  final String projectId;
  final String bidId;
  const AwardRequested({required this.projectId, required this.bidId});

  @override
  List<Object?> get props => [projectId, bidId];
}
