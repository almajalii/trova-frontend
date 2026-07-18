import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';

class CapabilityScoreService {
  final Dio dio;
  CapabilityScoreService({required this.dio});

  Future<CapabilityScore> fetchMyScore() async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return CapabilityScore.demo();
    }
    try {
      final response = await dio.get('/capability-score/me');
      return CapabilityScore.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
