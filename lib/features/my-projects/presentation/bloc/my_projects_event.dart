import 'package:equatable/equatable.dart';

abstract class MyProjectsEvent extends Equatable {
  const MyProjectsEvent();
  @override
  List<Object?> get props => [];
}

/// Fired on screen init, and again on pull-to-refresh.
class MyProjectsLoadRequested extends MyProjectsEvent {
  const MyProjectsLoadRequested();
}
