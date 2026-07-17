import 'package:dio/dio.dart';
import 'package:trova/core/models/auth_result.dart';
import 'package:trova/core/models/user_model.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/core/services/biometric_auth_service.dart';
import 'package:trova/core/storage/token_storage.dart';

class BiometricLoginService {
  final Dio dio;
  final TokenStorage tokenStorage;
  final BiometricAuthService biometricAuthService;

  BiometricLoginService({
    required this.dio,
    required this.tokenStorage,
    required this.biometricAuthService,
  });

  Future<AuthResult> unlockWithBiometrics() async {
    if (!await tokenStorage.isBiometricEnabled()) {
      throw ApiException('Biometric login is not enabled on this device.');
    }

    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      await tokenStorage.setBiometricEnabled(false);
      throw ApiException('Your session has expired. Please log in with your password.');
    }

    final authenticated = await biometricAuthService.authenticate();
    if (!authenticated) {
      throw ApiException('Biometric authentication was not successful.');
    }

    try {
      final response = await dio.get('/auth/me');
      final user = UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
      return AuthResult(token: token, user: user);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await tokenStorage.clearToken();
        await tokenStorage.setBiometricEnabled(false);
      }
      throw ApiException.fromDioException(e);
    }
  }
}
