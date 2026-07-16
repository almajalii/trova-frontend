import 'package:trova/features/log-in/logic/login_model.dart';

class LoginService {
  Future<bool> submitLogin(LoginData data) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network call

    if (data.email.isEmpty || data.password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    // Static success for now — replace with real API call tomorrow.
    return true;
  }
}