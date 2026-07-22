import 'package:dio/dio.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/mybids/logic/mybid_model.dart';

class BidsService {
  final Dio dio;
  BidsService({required this.dio});

  Future<List<BidModel>> fetchBids() async {
    try {
      final response = await dio.get('/bids/mine');
      return _parseBidsList(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<BidModel>> confirmBid(String id) async {
    try {
      final response = await dio.post('/bids/$id/confirm');
      return _parseBidsList(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<BidModel>> cancelBid(String id) async {
    try {
      final response = await dio.post('/bids/$id/cancel');
      return _parseBidsList(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<BidModel>> markWorkAsDone(String id) async {
    throw UnimplementedError('wired in a follow-up task');
  }

  Future<List<BidModel>> backOff(String id) async {
    try {
      final response = await dio.post('/bids/$id/back-off');
      return _parseBidsList(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  List<BidModel> _parseBidsList(dynamic data) {
    return (data['data'] as List).map((e) => BidModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
