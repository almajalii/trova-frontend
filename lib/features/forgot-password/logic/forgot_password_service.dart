import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';

/// NOTE: not on TrovaBackend yet — matches GoFix's ForgotPasswordRequest /
/// ResetPasswordRequest shapes so it's a straight port later.
///
/// GoFix's flow has no separate "verify code" endpoint: the code emailed to
/// the user IS the reset token, and it's submitted together with the new
/// password directly to /auth/reset-password. The "Check Your Email" OTP
/// screen is just UI for capturing that code before the next step.
class ForgotPasswordService {
  final Dio dio;

  ForgotPasswordService({required this.dio});

  Future<void> requestReset(String email) async {
    try {
      await dio.post('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      throw ApiException('Passwords do not match');
    }
    try {
      await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
