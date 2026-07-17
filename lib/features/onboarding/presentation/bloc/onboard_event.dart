
import 'package:equatable/equatable.dart';

abstract class OnboardEvent extends Equatable {
  const OnboardEvent();
  @override
  List<Object?> get props => [];
}

class OnboardStarted extends OnboardEvent {
  const OnboardStarted();
}

class OnboardingNext extends OnboardEvent {
  final int currentPage;
  const OnboardingNext({required this.currentPage});

  @override
  List<Object?> get props => [currentPage];
}

class OnboardingIndexChanged extends OnboardEvent {
  final int index;
  const OnboardingIndexChanged({required this.index});

  @override
  List<Object?> get props => [index];
}