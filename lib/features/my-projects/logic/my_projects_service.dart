import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/my-projects/logic/my_projects_model.dart';

class MyProjectsService {
  final Dio dio;
  MyProjectsService({required this.dio});

  Future<List<ProjectSummary>> fetchMyProjects() async {
    if (kUseMockMyProjects) {
      await Future.delayed(const Duration(milliseconds: 400));
      return ProjectSummary.demoList();
    }

    try {
      final response = await dio.get('/projects/mine');
      return (response.data['data'] as List).map((e) => ProjectSummary.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
