import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';

class BiddersService {
  final Dio dio;
  BiddersService({required this.dio});

  Future<List<Bidder>> fetchBidders(String projectId) async {
    if (kUseMockData) {
      await Future.delayed(const Duration(milliseconds: 400));
      return Bidder.demoList();
    }
    try {
      final response = await dio.get('/projects/$projectId/bids');
      return (response.data['data'] as List).map((e) => Bidder.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
