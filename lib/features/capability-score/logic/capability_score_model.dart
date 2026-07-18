// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/capability-score/me  (Bearer auth)
// Rule-based, no AI, as per the product spec. See field-level comments.
// {
//   "overallScore": 94,
//   "tierLabel": "Strong Capability",
//   "classification": { "code": "A", "label": "Large Enterprise" },
//   "trackRecordStats": { "totalProjects": 13, "failedProjects": 1, "avgRating": 4.8 },
//   "factors": {
//     "financialSolvency": {
//       "percentage": 96,
//       "description": "Verified via Open Finance access & approval",
//       "openFinanceData": {
//         "currentOutstandingDebtJod": 45000,
//         "additionalBorrowingCapacityJod": 120000,
//         "valueOfExistingAssetsJod": 310000,
//         "distressedDebtJod": 0,
//         "debtPaymentsSettled": 34,
//         "latePayments": 1
//       }
//     },
//     "projectTrackRecord": { "percentage": 92, "description": "12 of 13 projects completed on time" },
//     "pastProjectRatings": { "percentage": 95, "description": "Based on 11 project owner reviews" }
//   }
// }
// ───────────────────────────────────────────────────────────────────────

class ScoreClassification {
  final String code; // A | B | C
  final String label;
  const ScoreClassification({required this.code, required this.label});
  String get display => 'Class $code · $label';

  factory ScoreClassification.fromJson(Map<String, dynamic> json) =>
      ScoreClassification(code: json['code'] as String, label: json['label'] as String);
}

class TrackRecordStats {
  final int totalProjects;
  final int failedProjects;
  final double avgRating;
  const TrackRecordStats({required this.totalProjects, required this.failedProjects, required this.avgRating});

  factory TrackRecordStats.fromJson(Map<String, dynamic> json) => TrackRecordStats(
        totalProjects: json['totalProjects'] as int,
        failedProjects: json['failedProjects'] as int,
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

class OpenFinanceData {
  final double currentOutstandingDebtJod;
  final double additionalBorrowingCapacityJod;
  final double valueOfExistingAssetsJod;
  final double distressedDebtJod;
  final int debtPaymentsSettled;
  final int latePayments;

  const OpenFinanceData({
    required this.currentOutstandingDebtJod,
    required this.additionalBorrowingCapacityJod,
    required this.valueOfExistingAssetsJod,
    required this.distressedDebtJod,
    required this.debtPaymentsSettled,
    required this.latePayments,
  });

  factory OpenFinanceData.fromJson(Map<String, dynamic> json) => OpenFinanceData(
        currentOutstandingDebtJod: (json['currentOutstandingDebtJod'] as num).toDouble(),
        additionalBorrowingCapacityJod: (json['additionalBorrowingCapacityJod'] as num).toDouble(),
        valueOfExistingAssetsJod: (json['valueOfExistingAssetsJod'] as num).toDouble(),
        distressedDebtJod: (json['distressedDebtJod'] as num).toDouble(),
        debtPaymentsSettled: json['debtPaymentsSettled'] as int,
        latePayments: json['latePayments'] as int,
      );
}

class CapabilityScore {
  final int overallScore;
  final String tierLabel;
  final ScoreClassification classification;
  final TrackRecordStats trackRecordStats;
  final ScoreFactor financialSolvency;
  final OpenFinanceData openFinanceData;
  final ScoreFactor projectTrackRecord;
  final ScoreFactor pastProjectRatings;

  const CapabilityScore({
    required this.overallScore,
    required this.tierLabel,
    required this.classification,
    required this.trackRecordStats,
    required this.financialSolvency,
    required this.openFinanceData,
    required this.projectTrackRecord,
    required this.pastProjectRatings,
  });

  factory CapabilityScore.fromJson(Map<String, dynamic> json) {
    final factors = json['factors'] as Map<String, dynamic>;
    final financial = factors['financialSolvency'] as Map<String, dynamic>;
    return CapabilityScore(
      overallScore: json['overallScore'] as int,
      tierLabel: json['tierLabel'] as String,
      classification: ScoreClassification.fromJson(json['classification'] as Map<String, dynamic>),
      trackRecordStats: TrackRecordStats.fromJson(json['trackRecordStats'] as Map<String, dynamic>),
      financialSolvency: ScoreFactor.fromJson('Financial Solvency', financial),
      openFinanceData: OpenFinanceData.fromJson(financial['openFinanceData'] as Map<String, dynamic>),
      projectTrackRecord: ScoreFactor.fromJson('Project Track Record', factors['projectTrackRecord'] as Map<String, dynamic>),
      pastProjectRatings: ScoreFactor.fromJson('Past Project Ratings', factors['pastProjectRatings'] as Map<String, dynamic>),
    );
  }

  /// Demo data matching the Figma mock — used by the dev screens gallery.
  static CapabilityScore demo() => const CapabilityScore(
        overallScore: 94,
        tierLabel: 'Strong Capability',
        classification: ScoreClassification(code: 'A', label: 'Large Enterprise'),
        trackRecordStats: TrackRecordStats(totalProjects: 13, failedProjects: 1, avgRating: 4.8),
        financialSolvency: ScoreFactor(label: 'Financial Solvency', percentage: 96, description: 'Verified via Open Finance access & approval'),
        openFinanceData: OpenFinanceData(
          currentOutstandingDebtJod: 45000,
          additionalBorrowingCapacityJod: 120000,
          valueOfExistingAssetsJod: 310000,
          distressedDebtJod: 0,
          debtPaymentsSettled: 34,
          latePayments: 1,
        ),
        projectTrackRecord: ScoreFactor(label: 'Project Track Record', percentage: 92, description: '12 of 13 projects completed on time'),
        pastProjectRatings: ScoreFactor(label: 'Past Project Ratings', percentage: 95, description: 'Based on 11 project owner reviews'),
      );
}
