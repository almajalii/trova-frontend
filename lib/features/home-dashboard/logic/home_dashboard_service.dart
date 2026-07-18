import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/home-dashboard/logic/home_dashboard_model.dart';

class HomeDashboardService {
  final Dio dio;
  HomeDashboardService({required this.dio});

  Future<HomeSummary> fetchSummary() async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return HomeSummary.demo();
    }
    try {
      final response = await dio.get('/home/summary');
      return HomeSummary.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
