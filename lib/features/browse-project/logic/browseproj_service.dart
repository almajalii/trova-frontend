import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';
import 'package:trova/features/browse-project/logic/browseproj_model.dart';

class ProjectsService {
  final Dio dio;
  ProjectsService({required this.dio});

  Future<List<ProjectModel>> fetchProjects({ProjectsFilter? filter}) async {
    try {
      final queryParameters = <String, dynamic>{};
      if (filter?.sector != null) {
        queryParameters['sectors'] = [filter!.sector];
      }
      if (filter?.minValue != null) {
        queryParameters['minValue'] = filter!.minValue;
      }
      if (filter?.maxValue != null) {
        queryParameters['maxValue'] = filter!.maxValue;
      }

      final response = await dio.get('/projects/browse', queryParameters: queryParameters);
      final projects = (response.data['data'] as List)
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final sortBy = filter?.sortBy ?? 'value_desc';
      switch (sortBy) {
        case 'value_desc':
          projects.sort((a, b) => b.contractValueJod.compareTo(a.contractValueJod));
          break;
        case 'value_asc':
          projects.sort((a, b) => a.contractValueJod.compareTo(b.contractValueJod));
          break;
      }

      return projects;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
