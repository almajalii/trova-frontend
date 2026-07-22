import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:trova/core/network/api_config.dart';
import 'package:trova/core/storage/token_storage.dart';

/// Builds a configured Dio instance:
///  - base URL resolved per platform (see ApiConfig)
///  - automatically attaches "Authorization: Bearer `<token>`" when available
///  - logs requests/responses in debug builds only
class DioClient {
  static Dio create(TokenStorage tokenStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return dio;
  }
}
