import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';

class CapabilityScoreService {
  final Dio dio;
  CapabilityScoreService({required this.dio});

  /// Fetches the current user's capability score. Throws an [ApiException]
  /// with [ApiException.isNotFound] set when the user hasn't connected a
  /// bank account yet (404).
  Future<CapabilityScore> fetchMyScore() async {
    try {
      final response = await dio.get('/capability-score/me');
      return CapabilityScore.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
