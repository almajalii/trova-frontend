import 'package:trova/features/capability-score/logic/capability_score_model.dart';
import 'package:trova/features/company-details/logic/company_details_model.dart';
import 'package:trova/features/company-profile/logic/company_reviews_model.dart';

class CompanyProfile {
  final CompanyDetailsRecord details;
  // Null when the user hasn't connected a bank yet (score isn't computed
  // until then) — the profile screen just omits the score pill in that case.
  final CapabilityScore? score;
  final CompanyReviewsSummary reviews;

  const CompanyProfile({required this.details, this.score, required this.reviews});
}
