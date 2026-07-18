import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/post-project/logic/post_project_model.dart';

class PostProjectService {
  final Dio dio;
  PostProjectService({required this.dio});

  Future<String> submitProject(ProjectDraft draft) async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return 'mock-project-id-123';
    }
    try {
      final response = await dio.post('/projects', data: draft.toJson());
      return response.data['data']['projectId'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
