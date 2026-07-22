import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';
import 'package:trova/features/capability-score/logic/capability_score_service.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';
import 'package:trova/features/company-details/logic/company_details_service.dart';
import 'package:trova/features/company-profile/logic/company_profile_model.dart';
import 'package:trova/features/company-profile/logic/company_reviews_model.dart';
import 'package:trova/features/company-profile/logic/company_reviews_service.dart';

class CompanyProfileService {
  final CompanyDetailsService companyDetailsService;
  final CapabilityScoreService capabilityScoreService;
  final CompanyReviewsService companyReviewsService;

  CompanyProfileService({
    required this.companyDetailsService,
    required this.capabilityScoreService,
    required this.companyReviewsService,
  });

  /// Throws an [ApiException] with [ApiException.isNotFound] set when the
  /// user hasn't submitted Company Details yet — there's nothing to show a
  /// profile for until then. Score and reviews are best-effort: score is
  /// null if the user hasn't connected a bank yet (no score computed), and
  /// reviews always resolve (mocked — see company_reviews_service.dart).
  Future<CompanyProfile> fetchProfile() async {
    final results = await Future.wait([
      companyDetailsService.fetchMyCompanyDetails(),
      _fetchScore(),
      companyReviewsService.fetchMyReviews(),
    ]);
    return CompanyProfile(
      details: results[0] as CompanyDetailsRecord,
      score: results[1] as CapabilityScore?,
      reviews: results[2] as CompanyReviewsSummary,
    );
  }

  Future<CapabilityScore?> _fetchScore() async {
    try {
      return await capabilityScoreService.fetchMyScore();
    } on ApiException {
      return null;
    }
  }
}
