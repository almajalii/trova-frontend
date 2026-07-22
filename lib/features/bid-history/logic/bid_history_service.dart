import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/bid-history/logic/bid_history_model.dart';

class BidHistoryService {
  final Dio dio;
  BidHistoryService({required this.dio});

  Future<List<BidHistoryModel>> fetchBidHistory() async {
    if (kUseMockBidHistory) {
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockHistory;
    }

    try {
      final response = await dio.get('/bids/mine/history');
      return (response.data['data'] as List)
          .map((e) => BidHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  // Mock data mirrors the Figma "Bid History" screen. ids '7' and '2' match
  // entries in bid-detail's mock so tapping through works end-to-end.
  static const _mockHistory = [
    BidHistoryModel(
      id: '7',
      projectTitle: 'Marka Textile Fit-out',
      companyName: 'Marka Retail Holdings',
      bidAmount: 58000,
      status: 'completed',
      reviewRating: 5,
      reviewText:
          'Excellent execution and communication. The team delivered ahead of schedule and the quality exceeded expectations.',
    ),
    BidHistoryModel(
      id: '2',
      projectTitle: 'Riverside Complex Phase 2',
      companyName: 'Riverside Holdings',
      bidAmount: 1180000,
      status: 'rejected',
      note: 'Owner selected another contractor',
    ),
    BidHistoryModel(
      id: '5',
      projectTitle: 'Amman Trade Center',
      companyName: 'Al-Noor Development',
      bidAmount: 96000,
      status: 'backedOff',
      note: 'You withdrew after the guarantee was rejected.',
    ),
  ];
}
