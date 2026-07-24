// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// Two lookups, same response shape, different authorization scope:
//
// GET /api/bids/{bidId}/owner-profile  (Bearer auth)
// Used post-bid (My Bids / Bid Detail). Scoped by bidId (not a raw owner
// id) so only the contractor who actually placed that bid can view it —
// mirrors GET /bids/{bidId}/company-profile, the same lookup in the other
// direction (owner viewing a bidder).
//
// GET /api/projects/{projectId}/owner-profile  (Bearer auth)  — NOT YET LIVE
// Used pre-bid, from "Posted by {company}" on the browse/Submit Bid
// screen, where no bid exists yet. Needs a different authorization rule:
// any authenticated contractor viewing that open project (same visibility
// as the project listing itself), not "only the bidder on this bid".
//
// {
//   "tradingName": "Al-Noor Development", "registrationNumber": "JO-CR-118820",
//   "taxVatNumber": "JO-TAX-994512", "legalStructure": "Limited Liability Company (LLC)",
//   "yearOfEstablishment": 2012, "registeredAddress": "Abdali, Amman, Jordan",
//   "countryOfRegistration": "Jordan",
//   "primaryContactName": "Layla Haddad", "positionTitle": "Development Manager",
//   "primaryEmail": "layla.haddad@alnoor.jo", "primaryPhoneNumber": "+962 79 555 1234",
//   "businessLicenseNumber": "JO-LIC-55291", "yearsOfExperience": 14,
//   "sectorsPosted": ["Construction", "Real Estate"],
//   "trackRecordStats": { "totalProjectsPosted": 9, "activeProjects": 2, "completedProjects": 6, "avgRating": 4.6 }
// }
// ───────────────────────────────────────────────────────────────────────

class OwnerProfileDetails {
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
  final int yearsOfExperience;
  final List<String> sectorsPosted;

  const OwnerProfileDetails({
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
    required this.yearsOfExperience,
    required this.sectorsPosted,
  });

  factory OwnerProfileDetails.fromJson(Map<String, dynamic> json) => OwnerProfileDetails(
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
        yearsOfExperience: json['yearsOfExperience'] as int,
        sectorsPosted: List<String>.from(json['sectorsPosted'] as List),
      );
}

class OwnerTrackRecordStats {
  final int totalProjectsPosted;
  final int activeProjects;
  final int completedProjects;
  final double avgRating;

  const OwnerTrackRecordStats({
    required this.totalProjectsPosted,
    required this.activeProjects,
    required this.completedProjects,
    required this.avgRating,
  });

  factory OwnerTrackRecordStats.fromJson(Map<String, dynamic> json) => OwnerTrackRecordStats(
        totalProjectsPosted: json['totalProjectsPosted'] as int,
        activeProjects: json['activeProjects'] as int,
        completedProjects: json['completedProjects'] as int,
        avgRating: (json['avgRating'] as num).toDouble(),
      );
}

class OwnerFullProfile {
  final String companyName;
  final OwnerProfileDetails details;
  final OwnerTrackRecordStats stats;

  const OwnerFullProfile({
    required this.companyName,
    required this.details,
    required this.stats,
  });

  factory OwnerFullProfile.fromJson(String companyName, Map<String, dynamic> json) => OwnerFullProfile(
        companyName: companyName,
        details: OwnerProfileDetails.fromJson(json),
        stats: OwnerTrackRecordStats.fromJson(json['trackRecordStats'] as Map<String, dynamic>),
      );

  /// Deterministic mock, derived from the owner's company name so it stays
  /// self-consistent and stable across rebuilds instead of showing random
  /// unrelated numbers. Mirrors BidderFullProfile.demo().
  factory OwnerFullProfile.demo({required String companyName}) {
    final hash = companyName.hashCode.abs();
    final totalProjectsPosted = 3 + (hash % 15);
    final activeProjects = 1 + (hash % 4);
    final completedProjects = (totalProjectsPosted - activeProjects).clamp(0, totalProjectsPosted);
    final avgRating = double.parse((3.5 + (hash % 15) / 10).clamp(1.0, 5.0).toStringAsFixed(1));
    final slug = companyName.toLowerCase().replaceAll(RegExp(r'[^a-z]+'), '.');

    return OwnerFullProfile(
      companyName: companyName,
      details: OwnerProfileDetails(
        tradingName: companyName,
        registrationNumber: 'JO-CR-${100000 + hash % 900000}',
        taxVatNumber: 'JO-TAX-${100000 + hash % 900000}',
        legalStructure: 'Limited Liability Company (LLC)',
        yearOfEstablishment: 2008 + (hash % 16),
        registeredAddress: 'Amman, Jordan',
        countryOfRegistration: 'Jordan',
        primaryContactName: 'Project Owner Contact',
        positionTitle: 'Development Manager',
        primaryEmail: 'contact@$slug.jo',
        primaryPhoneNumber: '+962 79 000 0000',
        businessLicenseNumber: 'JO-LIC-${10000 + hash % 90000}',
        yearsOfExperience: 5 + (hash % 20),
        sectorsPosted: const ['Construction'],
      ),
      stats: OwnerTrackRecordStats(
        totalProjectsPosted: totalProjectsPosted,
        activeProjects: activeProjects,
        completedProjects: completedProjects,
        avgRating: avgRating,
      ),
    );
  }
}
