import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/core/network/request_flags.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

class BankConnectionService {
  final Dio dio;
  BankConnectionService({required this.dio});

  // Both calls here happen mid-onboarding — before company details are even
  // submitted through to right after — while the account is still routinely
  // "pending". They're marked exempt from the global approval-redirect
  // interceptor since a 403 here is expected and already handled locally
  // (empty list + retry / a BankConnectionError state) rather than needing
  // to bounce the user to the Pending Approval screen mid-signup.

  Future<List<BankOption>> fetchAvailableBanks() async {
    try {
      final response = await dio.get('/bank-connection/banks', options: suppressApprovalRedirectOptions);
      return (response.data['data'] as List).map((e) => BankOption.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Kicks off the Open Finance authorization flow for the chosen bank.
  /// Returns the authoritative bank name from the backend's response.
  Future<String> connect({
    required String bankCode,
    required double remainingDebtCapacityJod,
    required int numberOfDelinquentDebts,
    required int numberOfCurrentDebts,
  }) async {
    try {
      final response = await dio.post(
        '/bank-connection/connect',
        data: {
          'bankCode': bankCode,
          'remainingDebtCapacityJod': remainingDebtCapacityJod,
          'numberOfDelinquentDebts': numberOfDelinquentDebts,
          'numberOfCurrentDebts': numberOfCurrentDebts,
        },
        options: suppressApprovalRedirectOptions,
      );
      return response.data['data']['bankName'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
