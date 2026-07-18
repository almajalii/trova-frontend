import 'package:equatable/equatable.dart';
import 'package:trova/features/post-project/logic/post_project_model.dart';

abstract class PostProjectEvent extends Equatable {
  const PostProjectEvent();
  @override
  List<Object?> get props => [];
}

class PostProjectSubmitted extends PostProjectEvent {
  final ProjectDraft draft;
  const PostProjectSubmitted({required this.draft});

  @override
  List<Object?> get props => [draft];
}
