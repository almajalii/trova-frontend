import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/capability-score/logic/capability_score_model.dart';
import 'package:trova/features/company-profile/logic/company_reviews_model.dart';

// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/bids/{bidId}/company-profile  (Bearer auth)
// Public-facing profile of the bidding company, shown when a project owner
// taps a bidder card on Compare Scores. Deliberately omits banking details
// (Primary Bank Name / IBAN / SWIFT / Branch) — those stay private to the
// company itself, never shown to a competing bidder or the project owner.
// {
//   "tradingName": "Al-Fahad Contracting", "registrationNumber": "JO-CR-118820",
//   "taxVatNumber": "JO-TAX-994512", "legalStructure": "Limited Liability Company (LLC)",
//   "yearOfEstablishment": 2015, "registeredAddress": "Wadi Saqra, Amman, Jordan",
//   "countryOfRegistration": "Jordan",
//   "primaryContactName": "Ahmad Khalil", "positionTitle": "Operations Director",
//   "primaryEmail": "ahmad.khalil@alfahad.jo", "primaryPhoneNumber": "+962 79 123 4567",
//   "businessLicenseNumber": "JO-LIC-55291", "contractorClassificationGrade": "Grade A",
//   "sectors": ["Construction", "MEP"], "yearsOfExperience": 11,
//   "trackRecordStats": { "totalProjects": 13, "failedProjects": 1, "avgRating": 4.8 },
//   "scoreBreakdown": { "financialSolvency": 96, "projectTrackRecord": 92, "pastProjectRatings": 95 },
//   "reviews": { "averageRating": 4.8, "totalReviews": 11, "items": [...] }
// }
// ───────────────────────────────────────────────────────────────────────

class BidderProfileScoreBreakdown {
  final int financialSolvencyPct;
  final int projectTrackRecordPct;
  final int pastProjectRatingsPct;

  const BidderProfileScoreBreakdown({
    required this.financialSolvencyPct,
    required this.projectTrackRecordPct,
    required this.pastProjectRatingsPct,
  });

  factory BidderProfileScoreBreakdown.fromJson(Map<String, dynamic> json) => BidderProfileScoreBreakdown(
        financialSolvencyPct: json['financialSolvency'] as int,
        projectTrackRecordPct: json['projectTrackRecord'] as int,
        pastProjectRatingsPct: json['pastProjectRatings'] as int,
      );

  /// Derived from the bidder's own subFactors (already shown on Compare
  /// Scores) rather than invented numbers, so this can never disagree with
  /// what the user just compared.
  factory BidderProfileScoreBreakdown.fromBidder(Bidder bidder) {
    final financialSolvency =
        (bidder.currentDebtsPct + bidder.debtCapacityPct + bidder.assetsValuePct + bidder.delinquentDebtsPct + bidder.cashflowTrendsPct) /
            5;
    final projectTrackRecord = (bidder.currentWorkloadPct + bidder.deliveryHistoryPct) / 2;
    return BidderProfileScoreBreakdown(
      financialSolvencyPct: financialSolvency.round(),
      projectTrackRecordPct: projectTrackRecord.round(),
      pastProjectRatingsPct: bidder.paymentHistoryPct,
    );
  }
}

class BidderProfileDetails {
  final String tradingName;
  final String registrationNumber;
  final String taxVatNumber;
  final String legalStructure;
  final int yearOfEstablishment;
  final String registeredAddress;
  final String countryOfRegistration;

  final String primaryContactName;
  final String positionTitle;
  final String primaryEmail;
  final String primaryPhoneNumber;

  final String businessLicenseNumber;
  final String contractorClassificationGrade;
  final List<String> sectors;
  final int yearsOfExperience;

  const BidderProfileDetails({
    required this.tradingName,
    required this.registrationNumber,
    required this.taxVatNumber,
    required this.legalStructure,
    required this.yearOfEstablishment,
    required this.registeredAddress,
    required this.countryOfRegistration,
    required this.primaryContactName,
    required this.positionTitle,
    required this.primaryEmail,
    required this.primaryPhoneNumber,
    required this.businessLicenseNumber,
    required this.contractorClassificationGrade,
    required this.sectors,
    required this.yearsOfExperience,
  });

  factory BidderProfileDetails.fromJson(Map<String, dynamic> json) => BidderProfileDetails(
        tradingName: json['tradingName'] as String,
        registrationNumber: json['registrationNumber'] as String,
        taxVatNumber: json['taxVatNumber'] as String,
        legalStructure: json['legalStructure'] as String,
        yearOfEstablishment: json['yearOfEstablishment'] as int,
        registeredAddress: json['registeredAddress'] as String,
        countryOfRegistration: json['countryOfRegistration'] as String,
        primaryContactName: json['primaryContactName'] as String,
        positionTitle: json['positionTitle'] as String,
        primaryEmail: json['primaryEmail'] as String,
        primaryPhoneNumber: json['primaryPhoneNumber'] as String,
        businessLicenseNumber: json['businessLicenseNumber'] as String,
        contractorClassificationGrade: json['contractorClassificationGrade'] as String,
        sectors: List<String>.from(json['sectors'] as List),
        yearsOfExperience: json['yearsOfExperience'] as int,
      );
}

class BidderFullProfile {
  final Bidder bidder;
  final BidderProfileDetails details;
  final TrackRecordStats trackRecordStats;
  final BidderProfileScoreBreakdown scoreBreakdown;
  final CompanyReviewsSummary reviews;

  const BidderFullProfile({
    required this.bidder,
    required this.details,
    required this.trackRecordStats,
    required this.scoreBreakdown,
    required this.reviews,
  });

  factory BidderFullProfile.fromJson(Bidder bidder, Map<String, dynamic> json) => BidderFullProfile(
        bidder: bidder,
        details: BidderProfileDetails.fromJson(json),
        trackRecordStats: TrackRecordStats.fromJson(json['trackRecordStats'] as Map<String, dynamic>),
        scoreBreakdown: BidderProfileScoreBreakdown.fromJson(json['scoreBreakdown'] as Map<String, dynamic>),
        reviews: CompanyReviewsSummary.fromJson(json['reviews'] as Map<String, dynamic>),
      );

  /// Deterministic mock, derived from the bidder's own data (name, score,
  /// existing subFactors) so it stays self-consistent and stable across
  /// rebuilds instead of showing random unrelated numbers.
  factory BidderFullProfile.demo(Bidder bidder) {
    final score = bidder.capabilityScore;
    final totalProjects = (score / 7).round().clamp(3, 30);
    final failedProjects = ((100 - score) / 6).round().clamp(0, 5);
    final avgRating = double.parse((3.0 + (score / 100) * 2.0).clamp(1.0, 5.0).toStringAsFixed(1));
    final slug = bidder.companyName.toLowerCase().replaceAll(RegExp(r'[^a-z]+'), '.');

    return BidderFullProfile(
      bidder: bidder,
      details: BidderProfileDetails(
        tradingName: bidder.companyName,
        registrationNumber: 'JO-CR-${100000 + bidder.companyName.hashCode.abs() % 900000}',
        taxVatNumber: 'JO-TAX-${100000 + bidder.companyName.hashCode.abs() % 900000}',
        legalStructure: 'Limited Liability Company (LLC)',
        yearOfEstablishment: 2010 + (bidder.companyName.hashCode.abs() % 14),
        registeredAddress: 'Amman, Jordan',
        countryOfRegistration: 'Jordan',
        primaryContactName: 'Operations Manager',
        positionTitle: 'Operations Manager',
        primaryEmail: 'contact@$slug.jo',
        primaryPhoneNumber: '+962 79 000 0000',
        businessLicenseNumber: 'JO-LIC-${10000 + bidder.companyName.hashCode.abs() % 90000}',
        contractorClassificationGrade: 'Grade ${bidder.classification}',
        sectors: const ['Construction'],
        yearsOfExperience: 5 + (bidder.companyName.hashCode.abs() % 20),
      ),
      trackRecordStats: TrackRecordStats(totalProjects: totalProjects, failedProjects: failedProjects, avgRating: avgRating),
      scoreBreakdown: BidderProfileScoreBreakdown.fromBidder(bidder),
      reviews: CompanyReviewsSummary(
        averageRating: avgRating,
        totalReviews: totalProjects,
        items: [
          CompanyReviewItem(
            reviewerName: 'Previous Client',
            projectTitle: 'Recent Project',
            stars: avgRating.round().clamp(1, 5),
            comment: 'Delivered on time and within budget. Great communication throughout.',
          ),
        ],
      ),
    );
  }
}
