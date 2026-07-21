import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/browse-project/logic/browseproj_filter.dart';
import 'package:trova/features/browse-project/logic/browseproj_model.dart';

class ProjectsService {
  final Dio dio;
  ProjectsService({required this.dio});

  /// Fetches the list of open projects, optionally filtered by [filter].
  Future<List<ProjectModel>> fetchProjects({ProjectsFilter? filter}) async {
    try {
      final response = await dio.get('/projects', queryParameters: {
        if (filter?.sector != null) 'sector': filter!.sector,
        if (filter?.minValue != null) 'minValue': filter!.minValue,
        if (filter?.maxValue != null) 'maxValue': filter!.maxValue,
        if (filter != null) 'sortBy': filter.sortBy,
      });
      final list = response.data['data'] as List;
      return list.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}