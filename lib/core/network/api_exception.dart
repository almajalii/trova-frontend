import 'package:dio/dio.dart';

/// The backend always responds with { success, message, data } — this pulls
/// out `message` on failure so the UI can show something meaningful instead
/// of a raw Dio/network exception string.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  /// True when the failure was a 404 — "not found" rather than a generic
  /// error, so calling code can distinguish e.g. "no company details yet"
  /// from a real failure.
  bool get isNotFound => statusCode == 404;

  @override
  String toString() => message;

  /// Builds an ApiException from a DioException, falling back gracefully
  /// if the server didn't return the expected shape (e.g. network down,
  /// server unreachable, unexpected 500 without JSON body).
  factory ApiException.fromDioException(DioException e) {
    final data = e.response?.data;
    final statusCode = e.response?.statusCode;

    if (data is Map && data['message'] is String && (data['message'] as String).isNotEmpty) {
      return ApiException(data['message'] as String, statusCode: statusCode);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Request timed out. Please check your connection and try again.', statusCode: statusCode);
      case DioExceptionType.connectionError:
        return ApiException('Could not reach the server. Please check your connection.', statusCode: statusCode);
      default:
        return ApiException('Something went wrong. Please try again.', statusCode: statusCode);
    }
  }
}
