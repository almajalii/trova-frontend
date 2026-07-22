import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/bidders/logic/bidder_profile_model.dart';

class BidderProfileService {
  final Dio dio;
  BidderProfileService({required this.dio});

  Future<BidderFullProfile> fetchProfile(Bidder bidder) async {
    if (kUseMockBidderProfiles) {
      await Future.delayed(const Duration(milliseconds: 300));
      return BidderFullProfile.demo(bidder);
    }
    try {
      final response = await dio.get('/bids/${bidder.bidId}/company-profile');
      return BidderFullProfile.fromJson(bidder, response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
