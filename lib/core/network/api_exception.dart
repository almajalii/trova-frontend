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

    // 403 + a body carrying `data.approvalStatus` means the account itself
    // isn't approved yet — every other 403 (missing/invalid auth, forbidden
    // action) has no such field and falls through to the generic handling
    // below unchanged.
    if (statusCode == 403 && data is Map && data['data'] is Map) {
      final inner = data['data'] as Map;
      final approvalStatus = inner['approvalStatus'];
      if (approvalStatus is String) {
        final message = data['message'] is String
            ? data['message'] as String
            : 'Your account is not approved yet.';
        return AccountNotApprovedException(
          message,
          statusCode: statusCode,
          approvalStatus: approvalStatus,
          rejectionReason: inner['rejectionReason'] as String?,
        );
      }
    }

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

/// Thrown instead of a plain [ApiException] when the 403 is specifically
/// because the logged-in user's account isn't approved yet (as opposed to a
/// missing/invalid token or a forbidden action). Callers that only ever do
/// `catch (e) { showToast(e.toString()) }` keep working unchanged since this
/// is still an ApiException — but the top-level app router checks
/// `e is AccountNotApprovedException` first and redirects to the pending/
/// rejected status screen instead of letting that generic toast show.
class AccountNotApprovedException extends ApiException {
  /// "pending" | "rejected"
  final String approvalStatus;
  final String? rejectionReason;

  AccountNotApprovedException(
    super.message, {
    super.statusCode,
    required this.approvalStatus,
    this.rejectionReason,
  });

  bool get isRejected => approvalStatus == 'rejected';
  bool get isPending => approvalStatus == 'pending';
}
