import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/review-work/logic/submitted_work_model.dart';

class ReviewWorkService {
  final Dio dio;
  ReviewWorkService({required this.dio});

  Future<SubmittedWork> fetchSubmittedWork(String projectId) async {
    if (kUseMockReviewWork) {
      await Future.delayed(const Duration(milliseconds: 400));
      return SubmittedWork.demoList().firstWhere(
        (w) => w.projectId == projectId,
        orElse: () => SubmittedWork.demoList().first,
      );
    }

    try {
      final response = await dio.get('/projects/$projectId/submitted-work');
      return SubmittedWork.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> confirmComplete(String projectId) async {
    if (kUseMockReviewWork) {
      await Future.delayed(const Duration(milliseconds: 400));
      return;
    }
    try {
      await dio.post('/projects/$projectId/confirm-complete');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> flagIssue(String projectId) async {
    if (kUseMockReviewWork) {
      await Future.delayed(const Duration(milliseconds: 400));
      return;
    }
    try {
      await dio.post('/projects/$projectId/flag-issue');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
