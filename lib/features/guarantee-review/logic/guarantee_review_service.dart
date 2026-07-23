import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';

class GuaranteeReviewService {
  final Dio dio;
  GuaranteeReviewService({required this.dio});

  Future<OwnerGuarantee> fetchGuarantee(String projectId) async {
    if (kUseMockGuaranteeReview) {
      await Future.delayed(const Duration(milliseconds: 400));
      return OwnerGuarantee.demoList().firstWhere(
        (g) => g.projectId == projectId,
        orElse: () => OwnerGuarantee.demoList().first,
      );
    }

    try {
      final response = await dio.get('/projects/$projectId/guarantee');
      return OwnerGuarantee.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<OwnerGuarantee> confirmGuarantee(OwnerGuarantee guarantee) async {
    if (kUseMockGuaranteeReview) {
      await Future.delayed(const Duration(milliseconds: 400));
      return guarantee.copyWith(status: OwnerGuaranteeStatus.active);
    }

    try {
      final response = await dio.post('/projects/${guarantee.projectId}/guarantee/confirm');
      return OwnerGuarantee.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<OwnerGuarantee> rejectGuarantee(OwnerGuarantee guarantee, {String? reason}) async {
    if (kUseMockGuaranteeReview) {
      await Future.delayed(const Duration(milliseconds: 400));
      return guarantee.copyWith(status: OwnerGuaranteeStatus.rejected, rejectionReason: reason);
    }

    try {
      final response = await dio.post('/projects/${guarantee.projectId}/guarantee/reject', data: {'reason': reason});
      return OwnerGuarantee.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
