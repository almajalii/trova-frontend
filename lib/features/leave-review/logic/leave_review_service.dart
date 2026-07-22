import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/leave-review/logic/leave_review_model.dart';

class LeaveReviewService {
  final Dio _dio;

  LeaveReviewService({required this._dio});

  /// Loads the review context (contractor name, project title, completed
  /// date) for [projectId], with an empty/unrated draft ready to fill in.
  Future<LeaveReviewDraft> fetchContext(String projectId) async {
    if (kUseMockLeaveReview) {
      await Future.delayed(const Duration(milliseconds: 300));
      final match = LeaveReviewDraft.demoList().where((d) => d.projectId == projectId).toList();
      if (match.isEmpty) {
        throw ApiException('No demo review context found for projectId: $projectId');
      }
      return match.first;
    }

    try {
      final response = await _dio.get('/owner/projects/$projectId/review-context');
      return LeaveReviewDraft.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  /// Submits the completed review. Throws [ApiException] if the backend
  /// rejects it (e.g. project not actually completed, or already reviewed).
  Future<void> submitReview(LeaveReviewDraft draft) async {
    if (kUseMockLeaveReview) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }

    try {
      await _dio.post('/owner/projects/${draft.projectId}/review', data: draft.toJson());
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
