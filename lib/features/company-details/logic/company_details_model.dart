// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// POST /api/company-details  (Bearer auth — tied to the just-verified user)
// {
//   "companyName": "Al-Fahad Contracting",
//   "sector": "Construction & Engineering",
//   "registrationNumber": "JO-2014-88213",
//   "yearsInOperation": 11,
//   "teamSize": 85,
//   "annualRevenueJod": 950000
// }
// → 201 { "data": { "classification": { "code": "A", "label": "Large Enterprise" } } }
//
// The classification returned here is what feeds the Capability Score
// (see CompanyClassificationFit in the admin scoring-weights screen) and
// is what shows up as "Class A · Large Enterprise" everywhere else in the
// app — Home Dashboard, My Score, Bidders List, etc.
// ───────────────────────────────────────────────────────────────────────

class CompanyDetailsDraft {
  final String companyName;
  final String sector;
  final String registrationNumber;
  final int yearsInOperation;
  final int teamSize;
  final double annualRevenueJod;

  const CompanyDetailsDraft({
    required this.companyName,
    required this.sector,
    required this.registrationNumber,
    required this.yearsInOperation,
    required this.teamSize,
    required this.annualRevenueJod,
  });

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'sector': sector,
        'registrationNumber': registrationNumber,
        'yearsInOperation': yearsInOperation,
        'teamSize': teamSize,
        'annualRevenueJod': annualRevenueJod,
      };
}
