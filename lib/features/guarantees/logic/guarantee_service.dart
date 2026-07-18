import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/guarantees/logic/guarantee_model.dart';

class GuaranteeService {
  final Dio dio;
  GuaranteeService({required this.dio});

  Future<Guarantee> requestGuarantee({
    required String projectId,
    required double amountJod,
    required GuaranteeType type,
  }) async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      final now = DateTime.now();
      return Guarantee(
        id: 'TRV-GT-88213',
        amountJod: amountJod,
        type: type,
        issuingBank: 'Arab Bank',
        validUntil: DateTime(now.year + 1, now.month, now.day),
        status: 'ACTIVE',
      );
    }
    try {
      final response = await dio.post(
        '/projects/$projectId/guarantees',
        data: {'amountJod': amountJod, 'type': type.apiValue},
      );
      return Guarantee.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
