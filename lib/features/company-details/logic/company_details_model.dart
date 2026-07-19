import 'package:trova/features/capability-score/logic/capability_score_model.dart';

// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// POST /api/company-details  (Bearer auth — tied to the just-verified user)
// {
//   "companyName": "Al-Fahad Contracting",
//   "sectors": ["Construction", "Infrastructure"],
//   "registrationNumber": "JO-2014-88213",
//   "yearsInOperation": 11,
//   "teamSize": 85,
//   "annualRevenueJod": 950000
// }
// → 201 { "data": { "classification": { "code": "A", "label": "Large Enterprise" } } }
//
// GET /api/company-details  (Bearer auth) — fetches the current user's
// previously-submitted company details, if any. 404 (data: null) means the
// user hasn't submitted yet.
// {
//   "companyName": "Al-Fahad Contracting",
//   "sectors": ["Construction", "Infrastructure"],
//   "registrationNumber": "JO-2014-88213",
//   "yearsInOperation": 11,
//   "teamSize": 85,
//   "annualRevenueJod": 950000,
//   "classification": { "code": "A", "label": "Large Enterprise" }
// }
//
// The classification returned here is what feeds the Capability Score
// (see CompanyClassificationFit in the admin scoring-weights screen) and
// is what shows up as "Class A · Large Enterprise" everywhere else in the
// app — Home Dashboard, My Score, Bidders List, etc.
// ───────────────────────────────────────────────────────────────────────

/// The fixed set of sectors the backend accepts — this is a closed enum,
/// not free text.
const List<String> kAllowedSectors = [
  'Construction',
  'Real Estate',
  'Infrastructure',
  'Industrial',
  'MEP',
  'Renovation & Fit-out',
];

class CompanyDetailsDraft {
  final String companyName;
  final List<String> sectors;
  final String registrationNumber;
  final int yearsInOperation;
  final int teamSize;
  final double annualRevenueJod;

  const CompanyDetailsDraft({
    required this.companyName,
    required this.sectors,
    required this.registrationNumber,
    required this.yearsInOperation,
    required this.teamSize,
    required this.annualRevenueJod,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'sectors': sectors,
        'registrationNumber': registrationNumber,
        'yearsInOperation': yearsInOperation,
        'teamSize': teamSize,
        'annualRevenueJod': annualRevenueJod,
      };
}

/// The current user's previously-submitted company details, as returned by
/// GET /company-details.
class CompanyDetailsRecord {
  final String companyName;
  final List<String> sectors;
  final String registrationNumber;
  final int yearsInOperation;
  final int teamSize;
  final double annualRevenueJod;
  final ScoreClassification classification;

  const CompanyDetailsRecord({
    required this.companyName,
    required this.sectors,
    required this.registrationNumber,
    required this.yearsInOperation,
    required this.teamSize,
    required this.annualRevenueJod,
    required this.classification,
  });

  factory CompanyDetailsRecord.fromJson(Map<String, dynamic> json) => CompanyDetailsRecord(
        companyName: json['companyName'] as String,
        sectors: List<String>.from(json['sectors'] as List),
        registrationNumber: json['registrationNumber'] as String,
        yearsInOperation: json['yearsInOperation'] as int,
        teamSize: json['teamSize'] as int,
        annualRevenueJod: (json['annualRevenueJod'] as num).toDouble(),
        classification: ScoreClassification.fromJson(json['classification'] as Map<String, dynamic>),
      );
}
