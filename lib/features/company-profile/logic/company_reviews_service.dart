import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/company-profile/logic/company_reviews_model.dart';

class CompanyReviewsService {
  final Dio dio;
  CompanyReviewsService({required this.dio});

  Future<CompanyReviewsSummary> fetchMyReviews() async {
    if (kUseMockCompanyReviews) {
      await Future.delayed(const Duration(milliseconds: 300));
      return CompanyReviewsSummary.demo();
    }
    try {
      final response = await dio.get('/company-profile/reviews');
      return CompanyReviewsSummary.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
