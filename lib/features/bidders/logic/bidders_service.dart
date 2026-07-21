import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';

class BiddersService {
  final Dio dio;
  BiddersService({required this.dio});

  Future<List<Bidder>> fetchBidders(String projectId) async {
    if (kUseMockBidders) {
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

  Future<AwardResult> awardBid(String projectId, String bidId) async {
    if (kUseMockBidders) {
      await Future.delayed(const Duration(milliseconds: 400));
      final bidder = Bidder.demoList().firstWhere((b) => b.bidId == bidId);
      return AwardResult(projectId: projectId, status: 'AWARDED', awardedCompanyName: bidder.companyName);
    }
    try {
      final response = await dio.post('/projects/$projectId/award', data: {'bidId': bidId});
      return AwardResult.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
