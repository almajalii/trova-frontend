import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';

/// Matches the pattern verify_email_service.dart already documents for
/// /auth/change-password — authenticated, backend reads the user from the
/// JWT, so only the passwords are sent (no email/id needed).
class ChangePasswordService {
  final Dio dio;
  ChangePasswordService({required this.dio});

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword != confirmPassword) {
      throw ApiException('Passwords do not match');
    }
    try {
      await dio.post(
        '/auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
