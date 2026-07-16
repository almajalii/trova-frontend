

import 'package:equatable/equatable.dart';
import 'package:trova/features/onboarding/logic/onboard_model.dart';

abstract class OnboardState extends Equatable{
  const OnboardState();
  @override 
  List<Object?> get props => [];


}

class OnboardingInitial extends OnboardState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardState{
  const OnboardingLoading();
}

class OnboardingSuccess extends OnboardState{
  final List<OnboardingItem> items;
   final int currentIndex;
   final bool isComplete;

  const OnboardingSuccess({required this.items, required this.currentIndex,  this.isComplete = false });
  @override
  List<Object?> get props => [items,currentIndex,isComplete];

}

class OnboardingError extends OnboardState{
  final String message;

   const OnboardingError({required this.message});
  @override
  List<Object?> get props => [message];
}



