import 'package:dio/dio.dart';
import 'package:trova/core/models/auth_result.dart';
import 'package:trova/core/models/user_model.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/core/storage/token_storage.dart';
import 'package:trova/features/log-in/logic/login_model.dart';

class LoginService {
  final Dio dio;
  final TokenStorage tokenStorage;

  LoginService({required this.dio, required this.tokenStorage});

  Future<AuthResult> submitLogin(LoginData data) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': data.email,
          'password': data.password,
        },
      );

      final result = AuthResult.fromJson(response.data['data'] as Map<String, dynamic>);

      // Persist the token immediately so subsequent authenticated calls work.
      await tokenStorage.saveToken(result.token);

      return result;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Re-fetches the current user, chiefly to re-check `approvalStatus` —
  /// used by the pending-approval screen's "Check Status" button and right
  /// after signup finishes, since accounts start "pending" and most
  /// endpoints 403 until an admin approves them.
  Future<UserModel> fetchCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');
      return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
