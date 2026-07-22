import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/project-bid-detail/logic/projectdetailbid_model.dart';

class ProjectBidDetailService {
  final Dio dio;
  ProjectBidDetailService({required this.dio});

  /// Fetches a single browsable project's detail. Throws an [ApiException]
  /// with [ApiException.isNotFound] set when the project doesn't exist or is
  /// no longer open for bids (404).
  Future<Project> fetchProjectDetail(String projectId) async {
    try {
      final response = await dio.get('/projects/browse/$projectId');
      return Project.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<SubmitBidResponse> submitBid({required String projectId, required double bidAmount}) async {
    try {
      final response = await dio.post('/projects/browse/$projectId/bid', data: {'bidAmountJod': bidAmount});
      return SubmitBidResponse.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
