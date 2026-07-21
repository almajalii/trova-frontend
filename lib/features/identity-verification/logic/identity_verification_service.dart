import 'dart:math';

import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';

/// Sanad remains FULLY MOCKED — deliberate team decision. Real government
/// eKYC integration isn't feasible in the time available. This simulates
/// the delay and returns the account's own name plus a randomly-generated
/// but realistic-looking National ID, so the flow demos convincingly
/// without showing someone else's name back at the user. Swap the method
/// body for a real call later if a genuine Sanad integration becomes
/// available.
///
/// Scan-ID capture/OCR is no longer mocked — see
/// presentation/screens/scan_id_screen.dart for the real camera + on-device
/// OCR flow.
///
/// [saveVerification] IS real — both the Sanad and Scan confirm screens call
/// it to persist the confirmed name/National ID/method to the backend via
/// POST /auth/verify-identity.
class IdentityVerificationService {
  final Dio dio;
  final Random _random;

  IdentityVerificationService({required this.dio, Random? random}) : _random = random ?? Random();

  Future<IdentityInfo> verifyWithSanad({required String fullName}) async {
    await Future.delayed(const Duration(seconds: 2));
    return IdentityInfo(fullName: fullName, nationalId: _generateNationalId());
  }

  /// Jordan's National ID ("الرقم الوطني") is a 10-digit number. There's no
  /// public checksum/format spec to replicate, so this just fakes a
  /// plausible-looking one for demo purposes (9-prefixed, like real ones
  /// commonly shown in samples) — it isn't a real government ID.
  String _generateNationalId() {
    final buffer = StringBuffer('9');
    for (var i = 0; i < 9; i++) {
      buffer.write(_random.nextInt(10));
    }
    return buffer.toString();
  }

  /// method must be exactly "sanad" or "scan" — matches the backend's
  /// VerifyIdentityRequest validation.
  Future<void> saveVerification({required String fullName, required String nationalId, required String method}) async {
    try {
      await dio.post('/auth/verify-identity', data: {'fullName': fullName, 'nationalId': nationalId, 'method': method});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
