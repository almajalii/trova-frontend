import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:trova/core/navigation/app_navigator.dart';
import 'package:trova/core/network/api_config.dart';
import 'package:trova/core/network/request_flags.dart';
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
        onError: (error, handler) {
          // A 403 with `data.approvalStatus` means the account itself isn't
          // approved yet — redirect to the pending/rejected status screen
          // globally instead of letting the calling screen show its normal
          // error UI. Every other 403 (and all 4xx/5xx) falls straight
          // through to `handler.next` unchanged.
          //
          // Requests flagged with kSuppressApprovalRedirectKey (see
          // request_flags.dart) are exempt — these are onboarding-time calls
          // (e.g. listing banks before company details are even submitted)
          // where a still-pending account 403ing is expected and already
          // handled locally by the calling screen; without this, the global
          // redirect would hijack the signup flow mid-onboarding.
          final suppressed = error.requestOptions.extra[kSuppressApprovalRedirectKey] == true;
          final responseData = error.response?.data;
          if (!suppressed && error.response?.statusCode == 403 && responseData is Map && responseData['data'] is Map) {
            final approvalStatus = (responseData['data'] as Map)['approvalStatus'];
            if (approvalStatus is String) {
              redirectForAccountApproval(approvalStatus, (responseData['data'] as Map)['rejectionReason'] as String?);
            }
          }
          handler.next(error);
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
