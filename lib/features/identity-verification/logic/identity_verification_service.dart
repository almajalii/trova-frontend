import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/identity-verification/logic/identity_info.dart';

/// Sanad remains FULLY MOCKED — deliberate team decision. Real government
/// eKYC integration isn't feasible in the time available. This simulates
/// the delay and returns fake-but-plausible data so the flow demos
/// convincingly. Swap the method body for a real call later if a genuine
/// Sanad integration becomes available.
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

  IdentityVerificationService({required this.dio});

  Future<IdentityInfo> verifyWithSanad() async {
    await Future.delayed(const Duration(seconds: 2));
    return const IdentityInfo(fullName: 'Ahmad Khalil Al-Rawi', nationalId: '9984512345');
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
