import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/project-history/logic/project_history_model.dart';

class ProjectHistoryService {
  final Dio dio;
  ProjectHistoryService({required this.dio});

  Future<List<HistoryProjectSummary>> fetchProjectHistory() async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return HistoryProjectSummary.demoList();
    }

    try {
      final response = await dio.get('/projects/mine/history');
      return (response.data['data'] as List)
          .map((e) => HistoryProjectSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
