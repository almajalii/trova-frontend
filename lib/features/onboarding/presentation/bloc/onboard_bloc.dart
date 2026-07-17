import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/onboarding/logic/onboard_service.dart';
import 'package:trova/features/onboarding/presentation/bloc/onboard_event.dart';
import 'package:trova/features/onboarding/presentation/bloc/onboard_state.dart';

class OnboardBloc extends Bloc<OnboardEvent, OnboardState> {
  final OnboardService onboardService;

  OnboardBloc({required this.onboardService}) : super(const OnboardingInitial()) {
    on<OnboardStarted>((event, emit) async {
      final seen = await onboardService.hasSeenOnboarding();
      final items = onboardService.onboardData;

      if (seen) {
        emit(OnboardingSuccess(items: items, currentIndex: 0, isComplete: true));
        return;
      }
      emit(OnboardingSuccess(items: items, currentIndex: 0));
    });
    on<OnboardingNext>((event, emit) {
      final items = onboardService.onboardData;
      emit(OnboardingSuccess(
        items: items,
        currentIndex: event.currentPage + 1,
      ));
    });
    on<OnboardingIndexChanged>((event, emit) {
      final items = onboardService.onboardData;
      emit(OnboardingSuccess(
        items: items,
        currentIndex: event.index,
      ));
    });
  }
}