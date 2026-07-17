import 'package:trova/core/models/user_model.dart';

/// Mirrors the backend's AuthResponse: { token, user }
/// Returned by both login and register on success.
class AuthResult {
  final String token;
  final UserModel user;

  const AuthResult({required this.token, required this.user});

  factory AuthResult.fromJson(Map<String, dynamic> json) => AuthResult(
        token: json['token'] as String,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );
}
