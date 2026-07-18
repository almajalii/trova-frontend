// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/{projectId}/bids
// [
//   {
//     "companyName": "Al-Fahad Contracting",
//     "capabilityScore": 94,
//     "bidAmountJod": 238000,
//     "classification": "A",
//     "eligible": true,                 // false => "Below required tier", not selectable
//     "subFactors": { "liquidity": 92, "revenue": 88, "debt": 95, "reputation": 97 }
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
  final int liquidityPct;
  final int revenuePct;
  final int debtPct;
  final int reputationPct;

  const Bidder({
    required this.companyName,
    required this.capabilityScore,
    required this.bidAmountJod,
    required this.classification,
    required this.eligible,
    required this.liquidityPct,
    required this.revenuePct,
    required this.debtPct,
    required this.reputationPct,
  });

  factory Bidder.fromJson(Map<String, dynamic> json) {
    final sub = json['subFactors'] as Map<String, dynamic>? ?? const {};
    return Bidder(
      companyName: json['companyName'] as String,
      capabilityScore: json['capabilityScore'] as int,
      bidAmountJod: (json['bidAmountJod'] as num).toDouble(),
      classification: json['classification'] as String,
      eligible: json['eligible'] as bool,
      liquidityPct: (sub['liquidity'] as num?)?.toInt() ?? 0,
      revenuePct: (sub['revenue'] as num?)?.toInt() ?? 0,
      debtPct: (sub['debt'] as num?)?.toInt() ?? 0,
      reputationPct: (sub['reputation'] as num?)?.toInt() ?? 0,
    );
  }

  static List<Bidder> demoList() => const [
        Bidder(companyName: 'Al-Fahad Contracting', capabilityScore: 94, bidAmountJod: 238000, classification: 'A', eligible: true, liquidityPct: 92, revenuePct: 88, debtPct: 95, reputationPct: 97),
        Bidder(companyName: 'Zamzam Builders', capabilityScore: 87, bidAmountJod: 245000, classification: 'B', eligible: true, liquidityPct: 84, revenuePct: 90, debtPct: 81, reputationPct: 92),
        Bidder(companyName: 'Horizon Engineering', capabilityScore: 81, bidAmountJod: 231000, classification: 'B', eligible: true, liquidityPct: 0, revenuePct: 0, debtPct: 0, reputationPct: 0),
        Bidder(companyName: 'Cedar Construction', capabilityScore: 76, bidAmountJod: 250000, classification: 'C', eligible: false, liquidityPct: 0, revenuePct: 0, debtPct: 0, reputationPct: 0),
        Bidder(companyName: 'Al-Manara Group', capabilityScore: 69, bidAmountJod: 226000, classification: 'C', eligible: false, liquidityPct: 0, revenuePct: 0, debtPct: 0, reputationPct: 0),
      ];
}
