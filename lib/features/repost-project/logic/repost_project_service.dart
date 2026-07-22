import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/repost-project/logic/repost_project_model.dart';

class RepostProjectService {
  final Dio _dio;

  RepostProjectService({required this._dio});

  /// Loads the prefilled draft for [projectId] (the project being reposted).
  Future<RepostProjectDraft> fetchDraft(String projectId) async {
    if (kUseMockRepostProject) {
      await Future.delayed(const Duration(milliseconds: 300));
      final draft = RepostProjectDraft.demoList().where((d) => d.originalProjectId == projectId).toList();
      if (draft.isEmpty) {
        throw ApiException('');
      }
      return draft.first;
    }

    try {
      final response = await _dio.get('/owner/projects/$projectId/repost-draft');
      return RepostProjectDraft.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Submits the (possibly edited) draft, creating a new active project.
  /// Returns the new project's id.
  Future<String> submitRepost(RepostProjectDraft draft) async {
    if (kUseMockRepostProject) {
      await Future.delayed(const Duration(milliseconds: 500));
      return 'TRV-PRJ-${DateTime.now().millisecondsSinceEpoch % 100000}';
    }

    try {
      final response = await _dio.post('/owner/projects/${draft.originalProjectId}/repost', data: draft.toJson());
      final data = response.data['data'] as Map<String, dynamic>;
      return data['newProjectId'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
