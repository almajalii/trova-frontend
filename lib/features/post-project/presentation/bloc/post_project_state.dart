import 'package:equatable/equatable.dart';

abstract class PostProjectState extends Equatable {
  const PostProjectState();
  @override
  List<Object?> get props => [];
}

class PostProjectInitial extends PostProjectState {
  const PostProjectInitial();
}

class PostProjectLoading extends PostProjectState {
  const PostProjectLoading();
}

class PostProjectSuccess extends PostProjectState {
  final String projectId;
  const PostProjectSuccess({required this.projectId});

  @override
  List<Object?> get props => [projectId];
}

class PostProjectError extends PostProjectState {
  final String message;
  const PostProjectError({required this.message});

  @override
  List<Object?> get props => [message];
}
