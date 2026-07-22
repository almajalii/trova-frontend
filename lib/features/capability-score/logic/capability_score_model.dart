// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/capability-score/me  (Bearer auth)
// Rule-based, no AI, as per the product spec. See field-level comments.
// {
//   "overallScore": 94,
//   "tierLabel": "Strong Capability",
//   "classification": { "code": "A", "label": "Large Enterprise" },
//   "trackRecordStats": { "totalProjects": 13, "failedProjects": 1, "currentProjects": 3, "avgRating": 4.8 },
//   "factors": {
//     "numberOfCurrentDebts": { "percentage": 8, "description": "..." },
//     "debtCapacity": { "percentage": 12, "description": "..." },
//     "companyAssetsValue": { "percentage": 10, "description": "..." },
//     "delinquentDebts": { "percentage": 12, "description": "..." },
//     "paymentHistory": { "percentage": 20, "description": "..." },
//     "currentWorkload": { "percentage": 12, "description": "..." },
//     "projectDeliveryHistory": { "percentage": 10, "description": "..." },
//     "cashflowTrends": { "percentage": 16, "description": "..." }
//   }
// }
// ───────────────────────────────────────────────────────────────────────

class ScoreClassification {
  final String code; // A | B | C
  final String label;
  const ScoreClassification({required this.code, required this.label});

  // Backend sometimes sends label already formatted as "Class A" instead of
  // just "Large Enterprise" — prepending "Class $code ·" unconditionally
  // then reads as "Class A · Class A". Only prepend it when label doesn't
  // already include the code.
  String get display {
    final trimmedLabel = label.trim();
    if (trimmedLabel.toLowerCase().contains('class $code'.toLowerCase())) {
      return trimmedLabel;
    }
    return 'Class $code · $trimmedLabel';
  }

  factory ScoreClassification.fromJson(Map<String, dynamic> json) =>
      ScoreClassification(code: json['code'] as String, label: json['label'] as String);
}

class TrackRecordStats {
  final int totalProjects;
  final int failedProjects;
  final int currentProjects;
  final double avgRating;
  const TrackRecordStats({
    required this.totalProjects,
    required this.failedProjects,
    required this.currentProjects,
    required this.avgRating,
  });

  factory TrackRecordStats.fromJson(Map<String, dynamic> json) => TrackRecordStats(
        totalProjects: json['totalProjects'] as int,
        failedProjects: json['failedProjects'] as int,
        currentProjects: json['currentProjects'] as int? ?? 0,
        avgRating: (json['avgRating'] as num).toDouble(),
      );
}

class ScoreFactor {
  final String label;
  final int percentage;
  final String description;
  const ScoreFactor({required this.label, required this.percentage, required this.description});

  factory ScoreFactor.fromJson(String label, Map<String, dynamic> json) =>
      ScoreFactor(label: label, percentage: json['percentage'] as int, description: json['description'] as String);
}

class CapabilityScore {
  final int overallScore;
  final String tierLabel;
  final ScoreClassification classification;
  final TrackRecordStats trackRecordStats;
  final ScoreFactor numberOfCurrentDebts;
  final ScoreFactor debtCapacity;
  final ScoreFactor companyAssetsValue;
  final ScoreFactor delinquentDebts;
  final ScoreFactor paymentHistory;
  final ScoreFactor currentWorkload;
  final ScoreFactor projectDeliveryHistory;
  final ScoreFactor cashflowTrends;

  const CapabilityScore({
    required this.overallScore,
    required this.tierLabel,
    required this.classification,
    required this.trackRecordStats,
    required this.numberOfCurrentDebts,
    required this.debtCapacity,
    required this.companyAssetsValue,
    required this.delinquentDebts,
    required this.paymentHistory,
    required this.currentWorkload,
    required this.projectDeliveryHistory,
    required this.cashflowTrends,
  });

  factory CapabilityScore.fromJson(Map<String, dynamic> json) {
    final factors = json['factors'] as Map<String, dynamic>;
    return CapabilityScore(
      overallScore: json['overallScore'] as int,
      tierLabel: json['tierLabel'] as String,
      classification: ScoreClassification.fromJson(json['classification'] as Map<String, dynamic>),
      trackRecordStats: TrackRecordStats.fromJson(json['trackRecordStats'] as Map<String, dynamic>),
      numberOfCurrentDebts: ScoreFactor.fromJson('Number of Current Debts', factors['numberOfCurrentDebts'] as Map<String, dynamic>),
      debtCapacity: ScoreFactor.fromJson('Debt Capacity', factors['debtCapacity'] as Map<String, dynamic>),
      companyAssetsValue: ScoreFactor.fromJson('Company Assets Value', factors['companyAssetsValue'] as Map<String, dynamic>),
      delinquentDebts: ScoreFactor.fromJson('Delinquent Debts', factors['delinquentDebts'] as Map<String, dynamic>),
      paymentHistory: ScoreFactor.fromJson('Payment History', factors['paymentHistory'] as Map<String, dynamic>),
      currentWorkload: ScoreFactor.fromJson('Current Workload', factors['currentWorkload'] as Map<String, dynamic>),
      projectDeliveryHistory: ScoreFactor.fromJson('Project Delivery History', factors['projectDeliveryHistory'] as Map<String, dynamic>),
      cashflowTrends: ScoreFactor.fromJson('Cashflow Trends', factors['cashflowTrends'] as Map<String, dynamic>),
    );
  }

  /// Demo data matching the Figma mock — used by the dev screens gallery.
  static CapabilityScore demo() => const CapabilityScore(
        overallScore: 94,
        tierLabel: 'Strong Capability',
        classification: ScoreClassification(code: 'A', label: 'Large Enterprise'),
        trackRecordStats: TrackRecordStats(totalProjects: 13, failedProjects: 1, currentProjects: 3, avgRating: 4.8),
        numberOfCurrentDebts: ScoreFactor(label: 'Number of Current Debts', percentage: 8, description: '2 active debts on record'),
        debtCapacity: ScoreFactor(label: 'Debt Capacity', percentage: 12, description: 'Additional borrowing capacity of JOD 120,000'),
        companyAssetsValue: ScoreFactor(label: 'Company Assets Value', percentage: 10, description: 'Verified assets valued at JOD 310,000'),
        delinquentDebts: ScoreFactor(label: 'Delinquent Debts', percentage: 12, description: 'No distressed or defaulted debt found'),
        paymentHistory: ScoreFactor(label: 'Payment History', percentage: 20, description: '34 of 35 payments settled on time'),
        currentWorkload: ScoreFactor(label: 'Current Workload', percentage: 12, description: '3 active projects in progress'),
        projectDeliveryHistory: ScoreFactor(label: 'Project Delivery History', percentage: 10, description: '12 of 13 projects completed on time'),
        cashflowTrends: ScoreFactor(label: 'Cashflow Trends', percentage: 16, description: 'Stable positive cashflow over the last 6 months'),
      );
}
