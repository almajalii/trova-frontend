import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';

class CompanyDetailsService {
  final Dio dio;
  CompanyDetailsService({required this.dio});

  /// Submits company details and returns the resulting classification
  /// label, e.g. "Class A · Large Enterprise".
  Future<String> submit(CompanyDetailsDraft draft) async {
    try {
      final response = await dio.post('/company-details', data: draft.toJson());
      final classification = response.data['data']['classification'] as Map<String, dynamic>;
      return 'Class ${classification['code']} · ${classification['label']}';
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
