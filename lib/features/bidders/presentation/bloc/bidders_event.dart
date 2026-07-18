import 'package:equatable/equatable.dart';

abstract class BiddersEvent extends Equatable {
  const BiddersEvent();
  @override
  List<Object?> get props => [];
}

class BiddersStarted extends BiddersEvent {
  final String projectId;
  const BiddersStarted({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}
