import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';

/// NOTE: TrovaBackend doesn't have these endpoints yet — only GoFix does.
/// This is written to match GoFix's VerifyEmailRequest shape ({ code }) and
/// its authenticated pattern (backend reads the user from the JWT, same as
/// /auth/change-password) so it's a straight port once TrovaBackend gets
/// AuthService.SendVerificationEmailAsync / VerifyEmailAsync.
class VerifyEmailService {
  final Dio dio;

  VerifyEmailService({required this.dio});

  Future<void> resendCode() async {
    try {
      await dio.post('/auth/send-verification-email');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> verifyCode(String code) async {
    try {
      await dio.post('/auth/verify-email', data: {'code': code});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
