import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bank-connection/logic/bank_connection_model.dart';

class BankConnectionService {
  final Dio dio;
  BankConnectionService({required this.dio});

  Future<List<BankOption>> fetchAvailableBanks() async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return BankOption.demoList();
    }
    try {
      final response = await dio.get('/bank-connection/available-banks');
      return (response.data['data'] as List).map((e) => BankOption.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Kicks off the Open Finance authorization flow for the chosen bank.
  Future<void> authorize(String bankCode) async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return;
    }
    try {
      await dio.post('/bank-connection/authorize', data: {'bankCode': bankCode});
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
