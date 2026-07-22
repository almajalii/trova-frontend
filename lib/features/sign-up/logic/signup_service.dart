import 'package:dio/dio.dart';
import 'package:trova/core/models/auth_result.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/sign-up/logic/signup_model.dart';

class SignupService {
  final Dio dio;
  final TokenStorage tokenStorage;

  SignupService({required this.dio, required this.tokenStorage});

  Future<AuthResult> submitSignup(SignupData data) async {
    if (data.password != data.confirmPassword) {
      throw ApiException('Passwords do not match');
    }

    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': '${data.firstName} ${data.lastName}',
          'email': data.workEmail,
          'phone': data.phoneNumber,
          'password': data.password,
          'confirmPassword': data.confirmPassword,
        },
      );

      final result = AuthResult.fromJson(response.data['data'] as Map<String, dynamic>);

      // Registration logs the user in immediately (backend returns a token),
      // so persist it the same way login does.
      await tokenStorage.saveToken(result.token);

      return result;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
