import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/owner-profile/logic/owner_profile_model.dart';

class OwnerProfileService {
  final Dio dio;
  OwnerProfileService({required this.dio});

  /// Exactly one of [bidId] / [projectId] must be provided — [bidId] for the
  /// post-bid lookup (My Bids / Bid Detail), [projectId] for the pre-bid
  /// lookup (browse / Submit Bid, where no bid exists yet). See the
  /// DATA SHAPE NOTE in owner_profile_model.dart for why these are two
  /// separate backend endpoints rather than one.
  Future<OwnerFullProfile> fetchProfile({String? bidId, String? projectId, required String companyName}) async {
    assert((bidId == null) != (projectId == null), 'Provide exactly one of bidId or projectId');

    final useMock = bidId != null ? kUseMockOwnerProfile : kUseMockOwnerProfileByProject;
    if (useMock) {
      await Future.delayed(const Duration(milliseconds: 300));
      return OwnerFullProfile.demo(companyName: companyName);
    }
    try {
      final path = bidId != null ? '/bids/$bidId/owner-profile' : '/projects/$projectId/owner-profile';
      final response = await dio.get(path);
      return OwnerFullProfile.fromJson(companyName, response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
