import 'package:trova/features/sign-up/logic/signup_model.dart';

class SignupService {
  Future<bool> submitSignup(SignupData data) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network call

    if (data.password != data.confirmPassword) {
      throw Exception('Passwords do not match');
    }

    // Static success for now — replace with real API call tomorrow.
    return true;
  }
}