import 'package:trova/features/capability-score/logic/capability_score_model.dart';

// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// POST /api/company-details  (Bearer auth — tied to the just-verified user)
// {
//   "legalCompanyName": "Al-Fahad Contracting LLC",
//   "tradingName": "Al-Fahad Contracting",
//   "registrationNumber": "JO-CR-118820",
//   "taxVatNumber": "JO-TAX-994512",
//   "legalStructure": "Limited Liability Company (LLC)",
//   "yearOfEstablishment": 2015,
//   "registeredAddress": "Wadi Saqra, Amman, Jordan",
//   "countryOfRegistration": "Jordan",
//   "primaryContactName": "Ahmad Khalil",
//   "positionTitle": "Operations Director",
//   "primaryEmail": "ahmad.khalil@company.jo",
//   "primaryPhoneNumber": "+962 79 123 4567",
//   "businessLicenseNumber": "JO-LIC-55291",
//   "contractorClassificationGrade": "Grade A (Ministry of Public Works)",
//   "sectors": ["Construction", "MEP"],
//   "yearsOfExperience": 11,
//   "teamSize": 85,
//   "annualRevenueJod": 950000,
//   "primaryBankName": "Arab Bank",
//   "ibanNumber": "JO94 ARAB 1234 5678",
//   "swiftBicCode": "ARABJOAX",
//   "bankBranchNameCity": "Abdali Branch, Amman"
// }
// → 201 { "data": { "classification": { "code": "A", "label": "Large Enterprise" } } }
//
// GET /api/company-details  (Bearer auth) — fetches the current user's
// previously-submitted company details, if any. 404 (data: null) means the
// user hasn't submitted yet. Returns the same shape as above, plus
// "classification".
//
// NOTE: teamSize and annualRevenueJod aren't shown on the "Tell Us About
// Your Company" Figma frame (node 180:46) — they're kept here because the
// classification formula (see CompanyClassificationFit) is a majority-of-3
// on team size, revenue, and years — dropping either would break scoring.
// Surfaced under Business Qualifications in the app even though the Figma
// mock doesn't show them.
//
// "sectors" corresponds to the Figma "Main Areas of Expertise" field —
// kept as a closed-enum multi-select (not free text) because Sectors is
// also used for Post-a-Project / Browse Projects filtering elsewhere.
//
// The classification returned here is what feeds the Capability Score
// (see CompanyClassificationFit in the admin scoring-weights screen) and
// is what shows up as "Class A · Large Enterprise" everywhere else in the
// app — Home Dashboard, My Score, Bidders List, etc.
// ───────────────────────────────────────────────────────────────────────

/// The fixed set of sectors the backend accepts — this is a closed enum,
/// not free text. Backs the "Main Areas of Expertise" field in the UI.
const List<String> kAllowedSectors = [
  'Construction',
  'Real Estate',
  'Infrastructure',
  'Industrial',
  'MEP',
  'Renovation & Fit-out',
];

class CompanyDetailsDraft {
  // Company Legal Info
  final String legalCompanyName;
  final String tradingName;
  final String registrationNumber;
  final String taxVatNumber;
  final String legalStructure;
  final int yearOfEstablishment;
  final String registeredAddress;
  final String countryOfRegistration;

  // Contact Information
  final String primaryContactName;
  final String positionTitle;
  final String primaryEmail;
  final String primaryPhoneNumber;

  // Business Qualifications
  final String businessLicenseNumber;
  final String contractorClassificationGrade;
  final List<String> sectors; // "Main Areas of Expertise"
  final int yearsOfExperience;
  final int teamSize;
  final double annualRevenueJod;

  // Banking Basics
  final String primaryBankName;
  final String ibanNumber;
  final String swiftBicCode;
  final String bankBranchNameCity;

  const CompanyDetailsDraft({
    required this.legalCompanyName,
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
    required this.teamSize,
    required this.annualRevenueJod,
    required this.primaryBankName,
    required this.ibanNumber,
    required this.swiftBicCode,
    required this.bankBranchNameCity,
  });

  Map<String, dynamic> toJson() => {
    'legalCompanyName': legalCompanyName,
    'tradingName': tradingName,
    'registrationNumber': registrationNumber,
    'taxVatNumber': taxVatNumber,
    'legalStructure': legalStructure,
    'yearOfEstablishment': yearOfEstablishment,
    'registeredAddress': registeredAddress,
    'countryOfRegistration': countryOfRegistration,
    'primaryContactName': primaryContactName,
    'positionTitle': positionTitle,
    'primaryEmail': primaryEmail,
    'primaryPhoneNumber': primaryPhoneNumber,
    'businessLicenseNumber': businessLicenseNumber,
    'contractorClassificationGrade': contractorClassificationGrade,
    'sectors': sectors,
    'yearsOfExperience': yearsOfExperience,
    'teamSize': teamSize,
    'annualRevenueJod': annualRevenueJod,
    'primaryBankName': primaryBankName,
    'ibanNumber': ibanNumber,
    'swiftBicCode': swiftBicCode,
    'bankBranchNameCity': bankBranchNameCity,
  };
}

/// The current user's previously-submitted company details, as returned by
/// GET /company-details.
class CompanyDetailsRecord {
  final String legalCompanyName;
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
  final int teamSize;
  final double annualRevenueJod;

  final String primaryBankName;
  final String ibanNumber;
  final String swiftBicCode;
  final String bankBranchNameCity;

  final ScoreClassification classification;

  const CompanyDetailsRecord({
    required this.legalCompanyName,
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
    required this.teamSize,
    required this.annualRevenueJod,
    required this.primaryBankName,
    required this.ibanNumber,
    required this.swiftBicCode,
    required this.bankBranchNameCity,
    required this.classification,
  });

  factory CompanyDetailsRecord.fromJson(Map<String, dynamic> json) => CompanyDetailsRecord(
    legalCompanyName: json['legalCompanyName'] as String,
    tradingName: json['tradingName'] as String? ?? '',
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
    teamSize: json['teamSize'] as int,
    annualRevenueJod: (json['annualRevenueJod'] as num).toDouble(),
    primaryBankName: json['primaryBankName'] as String,
    ibanNumber: json['ibanNumber'] as String,
    swiftBicCode: json['swiftBicCode'] as String,
    bankBranchNameCity: json['bankBranchNameCity'] as String,
    classification: ScoreClassification.fromJson(json['classification'] as Map<String, dynamic>),
  );
}
