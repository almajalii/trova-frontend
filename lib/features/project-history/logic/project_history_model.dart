// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/mine/history  (Bearer auth — owner's completed/disputed/
// failed projects; the active ones live on GET /projects/mine instead, see
// my-projects/logic/my_projects_model.dart)
// {
//   "data": [
//     {
//       "projectId": "TRV-PRJ-19042",
//       "title": "Downtown Office Renovation",
//       "status": "COMPLETED",
//       "contractValueJod": 85000,
//       "detailText": "Completed May 2026",
//       "guaranteeStripLabel": null,
//       "guaranteeStripSubtext": null
//     },
//     {
//       "projectId": "TRV-PRJ-55290",
//       "title": "Marka Logistics Center",
//       "status": "DISPUTED",
//       "contractValueJod": 62000,
//       "detailText": "Contractor: Cedar Construction",
//       "guaranteeStripLabel": "Flagged: quality concerns",
//       "guaranteeStripSubtext": "Under review"
//     }
//   ]
// }
// ───────────────────────────────────────────────────────────────────────

enum HistoryProjectStatus { completed, disputed, failed, cancelled }

extension HistoryProjectStatusX on HistoryProjectStatus {
  String get apiValue {
    switch (this) {
      case HistoryProjectStatus.completed:
        return 'COMPLETED';
      case HistoryProjectStatus.disputed:
        return 'DISPUTED';
      case HistoryProjectStatus.failed:
        return 'FAILED';
      case HistoryProjectStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static HistoryProjectStatus fromApiValue(String value) {
    return HistoryProjectStatus.values.firstWhere(
      (s) => s.apiValue == value,
      orElse: () => HistoryProjectStatus.completed,
    );
  }

  String get label {
    switch (this) {
      case HistoryProjectStatus.completed:
        return 'Completed';
      case HistoryProjectStatus.disputed:
        return 'Disputed';
      case HistoryProjectStatus.failed:
        return 'Failed';
      case HistoryProjectStatus.cancelled:
        return 'Reposted';
    }
  }
}

class HistoryProjectSummary {
  final String id;
  final String title;
  final HistoryProjectStatus status;
  final double contractValueJod;

  /// Secondary line under the value, e.g. "Completed May 2026" or
  /// "Contractor: Cedar Construction".
  final String detailText;

  /// Optional colored strip (Disputed + Failed cards only — Completed has
  /// none). Tone always matches the status badge tone, so unlike
  /// ProjectSummary there's no separate tone field here.
  final String? guaranteeStripLabel;
  final String? guaranteeStripSubtext;

  const HistoryProjectSummary({
    required this.id,
    required this.title,
    required this.status,
    required this.contractValueJod,
    required this.detailText,
    this.guaranteeStripLabel,
    this.guaranteeStripSubtext,
  });

  factory HistoryProjectSummary.fromJson(Map<String, dynamic> json) => HistoryProjectSummary(
    id: json['projectId'] as String,
    title: json['title'] as String,
    status: HistoryProjectStatusX.fromApiValue(json['status'] as String),
    contractValueJod: (json['contractValueJod'] as num).toDouble(),
    detailText: json['detailText'] as String,
    guaranteeStripLabel: json['guaranteeStripLabel'] as String?,
    guaranteeStripSubtext: json['guaranteeStripSubtext'] as String?,
  );

  /// Demo data matching the three example cards on the Figma
  /// "Project History" frame.
  static List<HistoryProjectSummary> demoList() => const [
    HistoryProjectSummary(
      id: 'TRV-PRJ-19042',
      title: 'Downtown Office Renovation',
      status: HistoryProjectStatus.completed,
      contractValueJod: 85000,
      detailText: 'Completed May 2026',
    ),
    HistoryProjectSummary(
      id: 'TRV-PRJ-55290',
      title: 'Marka Logistics Center',
      status: HistoryProjectStatus.disputed,
      contractValueJod: 62000,
      detailText: 'Contractor: Cedar Construction',
      guaranteeStripLabel: 'Flagged: quality concerns',
      guaranteeStripSubtext: 'Under review',
    ),
    HistoryProjectSummary(
      id: 'TRV-PRJ-08821',
      title: 'Old Amman Retail Fitout',
      status: HistoryProjectStatus.failed,
      contractValueJod: 34000,
      detailText: 'Contractor: Al-Manara Group',
      guaranteeStripLabel: 'Guarantee: Claimed',
      guaranteeStripSubtext: 'Contract not fulfilled',
    ),
  ];
}
