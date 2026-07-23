// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/{projectId}/bids
// [
//   {
//     "bidId": "51651ada-1711-4a99-81dc-00c076f726ba",
//     "companyName": "Al-Fahad Contracting",
//     "capabilityScore": 94,
//     "bidAmountJod": 238000,
//     "classification": "A",
//     "eligible": true,                 // false => "Below required tier", not selectable
//     "subFactors": {
//       "currentDebts": 96,
//       "debtCapacity": 90,
//       "assetsValue": 92,
//       "delinquentDebts": 100,
//       "paymentHistory": 98,
//       "currentWorkload": 88,
//       "deliveryHistory": 95,
//       "cashflowTrends": 92
//     }
//   },
//   ...
// ]
// ───────────────────────────────────────────────────────────────────────

class Bidder {
  final String bidId;
  final String companyName;
  final int capabilityScore;
  final double bidAmountJod;
  final String classification; // A | B | C
  final bool eligible;

  // Updated sub-factors to match Figma "Compare Scores" UI
  final int currentDebtsPct;
  final int debtCapacityPct;
  final int assetsValuePct;
  final int delinquentDebtsPct;
  final int paymentHistoryPct;
  final int currentWorkloadPct;
  final int deliveryHistoryPct;
  final int cashflowTrendsPct;

  const Bidder({
    required this.bidId,
    required this.companyName,
    required this.capabilityScore,
    required this.bidAmountJod,
    required this.classification,
    required this.eligible,
    required this.currentDebtsPct,
    required this.debtCapacityPct,
    required this.assetsValuePct,
    required this.delinquentDebtsPct,
    required this.paymentHistoryPct,
    required this.currentWorkloadPct,
    required this.deliveryHistoryPct,
    required this.cashflowTrendsPct,
  });

  /// Lightweight const constructor for contexts that only know the awarded
  /// contractor's name/id (Project Detail, My Projects, guarantees, reviews,
  /// etc.), not the full Compare Scores payload. Score-related fields are
  /// zeroed — BidderProfileLayout no longer renders a score ring/breakdown,
  /// so they're unused for this path. Kept `const` so demo lists elsewhere
  /// can stay `const` too.
  const Bidder.contractorRef({
    required this.bidId,
    required this.companyName,
    this.classification = 'A',
    this.eligible = true,
  }) : capabilityScore = 0,
       bidAmountJod = 0,
       currentDebtsPct = 0,
       debtCapacityPct = 0,
       assetsValuePct = 0,
       delinquentDebtsPct = 0,
       paymentHistoryPct = 0,
       currentWorkloadPct = 0,
       deliveryHistoryPct = 0,
       cashflowTrendsPct = 0;

  /// `capabilityScore`/`bidAmountJod`/`classification`/`eligible`/`subFactors`
  /// default when absent so this same shape can double as a lightweight
  /// "awarded contractor" reference elsewhere (e.g. Project Detail,
  /// My Projects) — those contexts only need `bidId` + `companyName` to
  /// resolve a tap-through to the bidder's profile; they don't carry the
  /// full Compare Scores payload.
  factory Bidder.fromJson(Map<String, dynamic> json) {
    final sub = json['subFactors'] as Map<String, dynamic>? ?? const {};
    return Bidder(
      bidId: json['bidId'] as String,
      companyName: json['companyName'] as String,
      capabilityScore: (json['capabilityScore'] as num?)?.toInt() ?? 0,
      bidAmountJod: (json['bidAmountJod'] as num?)?.toDouble() ?? 0,
      classification: json['classification'] as String? ?? '',
      eligible: json['eligible'] as bool? ?? true,
      currentDebtsPct: (sub['currentDebts'] as num?)?.toInt() ?? 0,
      debtCapacityPct: (sub['debtCapacity'] as num?)?.toInt() ?? 0,
      assetsValuePct: (sub['assetsValue'] as num?)?.toInt() ?? 0,
      delinquentDebtsPct: (sub['delinquentDebts'] as num?)?.toInt() ?? 0,
      paymentHistoryPct: (sub['paymentHistory'] as num?)?.toInt() ?? 0,
      currentWorkloadPct: (sub['currentWorkload'] as num?)?.toInt() ?? 0,
      deliveryHistoryPct: (sub['deliveryHistory'] as num?)?.toInt() ?? 0,
      cashflowTrendsPct: (sub['cashflowTrends'] as num?)?.toInt() ?? 0,
    );
  }

  static Bidder? fromJsonOrNull(Map<String, dynamic>? json) => json == null ? null : Bidder.fromJson(json);

  static List<Bidder> demoList() => const [
    Bidder(
      bidId: '51651ada-1711-4a99-81dc-00c076f726ba',
      companyName: 'Al-Fahad Contracting',
      capabilityScore: 94,
      bidAmountJod: 238000,
      classification: 'A',
      eligible: true,
      currentDebtsPct: 96,
      debtCapacityPct: 90,
      assetsValuePct: 92,
      delinquentDebtsPct: 100,
      paymentHistoryPct: 98,
      currentWorkloadPct: 88,
      deliveryHistoryPct: 95,
      cashflowTrendsPct: 92,
    ),
    Bidder(
      bidId: '6b2e1f3a-8c44-4d5b-9e21-3f7a2c9d1b04',
      companyName: 'Zamzam Builders',
      capabilityScore: 87,
      bidAmountJod: 245000,
      classification: 'B',
      eligible: true,
      currentDebtsPct: 64,
      debtCapacityPct: 78,
      assetsValuePct: 71,
      delinquentDebtsPct: 50,
      paymentHistoryPct: 88,
      currentWorkloadPct: 52,
      deliveryHistoryPct: 85,
      cashflowTrendsPct: 60,
    ),
    Bidder(
      bidId: 'd4a9f712-55e3-4b8a-9c60-1a2b3c4d5e6f',
      companyName: 'Horizon Engineering',
      capabilityScore: 81,
      bidAmountJod: 231000,
      classification: 'B',
      eligible: true,
      currentDebtsPct: 81,
      debtCapacityPct: 82,
      assetsValuePct: 79,
      delinquentDebtsPct: 85,
      paymentHistoryPct: 80,
      currentWorkloadPct: 75,
      deliveryHistoryPct: 88,
      cashflowTrendsPct: 80,
    ),
    Bidder(
      bidId: '8f3c2a1b-4d5e-4f60-8a7b-9c0d1e2f3a4b',
      companyName: 'Cedar Construction',
      capabilityScore: 76,
      bidAmountJod: 250000,
      classification: 'C',
      eligible: false,
      currentDebtsPct: 0,
      debtCapacityPct: 0,
      assetsValuePct: 0,
      delinquentDebtsPct: 0,
      paymentHistoryPct: 0,
      currentWorkloadPct: 0,
      deliveryHistoryPct: 0,
      cashflowTrendsPct: 0,
    ),
    Bidder(
      bidId: '2c7e9f10-3b4a-4d5c-8e6f-1a2b3c4d5e60',
      companyName: 'Al-Manara Group',
      capabilityScore: 69,
      bidAmountJod: 226000,
      classification: 'C',
      eligible: false,
      currentDebtsPct: 0,
      debtCapacityPct: 0,
      assetsValuePct: 0,
      delinquentDebtsPct: 0,
      paymentHistoryPct: 0,
      currentWorkloadPct: 0,
      deliveryHistoryPct: 0,
      cashflowTrendsPct: 0,
    ),
  ];
}

// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// POST /api/projects/{projectId}/award
// { "bidId": "51651ada-1711-4a99-81dc-00c076f726ba" }
// → 200 { "data": { "projectId": "TRV-PRJ-60214", "status": "AWARDED", "awardedCompanyName": "Al-Fahad Contracting" } }
// ───────────────────────────────────────────────────────────────────────

class AwardResult {
  final String projectId;
  final String status;
  final String awardedCompanyName;

  const AwardResult({required this.projectId, required this.status, required this.awardedCompanyName});

  factory AwardResult.fromJson(Map<String, dynamic> json) => AwardResult(
    projectId: json['projectId'] as String,
    status: json['status'] as String,
    awardedCompanyName: json['awardedCompanyName'] as String,
  );
}
