import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/routes.dart';
import 'package:trova/features/onboarding/presentation/bloc/onboard_bloc.dart';
import 'package:trova/features/onboarding/presentation/bloc/onboard_event.dart';
import 'package:trova/features/onboarding/presentation/bloc/onboard_state.dart';
import 'package:trova/features/onboarding/logic/onboard_service.dart';
import 'package:trova/features/onboarding/presentation/widgets/onboard_layout.dart';
import 'package:trova/features/onboarding/presentation/widgets/welcome_layout.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) =>
            OnboardBloc(onboardService: OnboardService())..add(const OnboardStarted()),
        child: BlocConsumer<OnboardBloc, OnboardState>(
          listener: (context, state) {
            if (state is OnboardingSuccess) {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  state.currentIndex,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              }
            }

            if (state is OnboardingSuccess && state.isComplete) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
          builder: (context, state) {
            if (state is OnboardingInitial || state is OnboardingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is OnboardingError) {
              return Center(child: Text(state.message));
            }

            if (state is OnboardingSuccess) {
              final totalPages = state.items.length + 1;

              return PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  final isLastPage = index == state.items.length;

                  if (isLastPage) {
                    return WelcomeLayout(
                      onLogin: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      onSignup: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.signup);
                      },
                      itemCount: totalPages,
                      currentIndex: state.currentIndex,
                    );
                  }

                  final item = state.items[index];
                  return OnboardLayout(
                    page: item,
                    currentIndex: state.currentIndex,
                    itemCount: totalPages,
                    onNext: () {
                      context.read<OnboardBloc>().add(
                            OnboardingNext(currentPage: state.currentIndex),
                          );
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}