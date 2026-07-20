// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/{projectId}/bids
// [
//   {
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

  factory Bidder.fromJson(Map<String, dynamic> json) {
    final sub = json['subFactors'] as Map<String, dynamic>? ?? const {};
    return Bidder(
      companyName: json['companyName'] as String,
      capabilityScore: json['capabilityScore'] as int,
      bidAmountJod: (json['bidAmountJod'] as num).toDouble(),
      classification: json['classification'] as String,
      eligible: json['eligible'] as bool,
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

  static List<Bidder> demoList() => const [
    Bidder(
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
