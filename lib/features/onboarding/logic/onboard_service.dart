import 'package:shared_preferences/shared_preferences.dart';
import 'package:trova/features/onboarding/logic/onboard_model.dart';

class OnboardService {
  static const _seenKey = 'seen_onboarding';

	List<OnboardingItem> get onboardData =>
		 [
			OnboardingItem(title: "Instant Financial Capability Scores", description: "We analyze real-time banking data through Open Finance to score contractor risk and capability — no paperwork required.", imagePath: "assets/images/auth/Ring_Badge1.svg"),
			OnboardingItem(title: "Instant Financial Capability Scores", description: "We analyze real-time banking data through Open Finance to score contractor risk and capability — no paperwork required.", imagePath: "assets/images/auth/Ring_Badge2.svg"),
			OnboardingItem(title: "Instant Financial Capability Scores", description: "We analyze real-time banking data through Open Finance to score contractor risk and capability — no paperwork required.", imagePath: "assets/images/auth/Ring_Badge3.svg"),
	];

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_seenKey, true);
  }

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_seenKey) ?? false;
  }
}