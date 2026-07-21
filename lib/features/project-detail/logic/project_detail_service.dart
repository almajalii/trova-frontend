import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/project-detail/logic/project_detail_model.dart';

class ProjectDetailService {
  final Dio dio;
  ProjectDetailService({required this.dio});

  Future<ProjectDetail> fetchProjectDetail(String projectId) async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return ProjectDetail.demoList().firstWhere(
        (p) => p.id == projectId,
        orElse: () => ProjectDetail.demoList().first,
      );
    }

    try {
      final response = await dio.get('/projects/$projectId');
      return ProjectDetail.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> submitBid({required String projectId, required double bidAmount}) async {}
}
