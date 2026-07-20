// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/{projectId}/submitted-work  (Bearer auth — owner side;
// only meaningful while the project's status is PENDING_REVIEW)
// {
//   "data": {
//     "projectId": "TRV-PRJ-33871",
//     "projectTitle": "Al-Salam Mall",
//     "sector": "Real Estate",
//     "location": "Al-Salam, Amman",
//     "contractValueJod": 152000,
//     "timelineText": "10 months (Jun 2026 – Apr 2027)",
//     "milestones": "Structure – M3, MEP – M7, Handover – M10",
//     "guaranteeTypeRequired": "Performance Guarantee",
//     "paymentTerms": "15% upfront / 70% milestones / 15% completion",
//     "contractorName": "Al-Fahad Contracting",
//     "submittedDate": "2026-07-18",
//     "guaranteeRowText": "Active · TRV-GT-77104"
//   }
// }
//
// POST /api/projects/{projectId}/confirm-complete  → project status becomes
// COMPLETED (moves to Project History)
// POST /api/projects/{projectId}/flag-issue        → project status becomes
// DISPUTED (moves to Project History, Trova's team steps in)
// ───────────────────────────────────────────────────────────────────────

class SubmittedWork {
  final String projectId;
  final String projectTitle;
  final String sector;
  final String location;
  final double contractValueJod;
  final String timelineText;
  final String milestones;
  final String guaranteeTypeRequired;
  final String paymentTerms;
  final String contractorName;
  final DateTime submittedDate;
  final String? guaranteeRowText;

  const SubmittedWork({
    required this.projectId,
    required this.projectTitle,
    required this.sector,
    required this.location,
    required this.contractValueJod,
    required this.timelineText,
    required this.milestones,
    required this.guaranteeTypeRequired,
    required this.paymentTerms,
    required this.contractorName,
    required this.submittedDate,
    this.guaranteeRowText,
  });

  factory SubmittedWork.fromJson(Map<String, dynamic> json) => SubmittedWork(
    projectId: json['projectId'] as String,
    projectTitle: json['projectTitle'] as String,
    sector: json['sector'] as String,
    location: json['location'] as String,
    contractValueJod: (json['contractValueJod'] as num).toDouble(),
    timelineText: json['timelineText'] as String,
    milestones: json['milestones'] as String,
    guaranteeTypeRequired: json['guaranteeTypeRequired'] as String,
    paymentTerms: json['paymentTerms'] as String,
    contractorName: json['contractorName'] as String,
    submittedDate: DateTime.parse(json['submittedDate'] as String),
    guaranteeRowText: json['guaranteeRowText'] as String?,
  );

  /// Demo data matching the one example on the Figma frame (Al-Salam Mall).
  /// Keyed to the same project id used in project-detail's Pending Review
  /// entry so the two feel connected.
  static List<SubmittedWork> demoList() => [
    SubmittedWork(
      projectId: 'TRV-PRJ-33871',
      projectTitle: 'Al-Salam Mall',
      sector: 'Real Estate',
      location: 'Al-Salam, Amman',
      contractValueJod: 152000,
      timelineText: '10 months (Jun 2026 – Apr 2027)',
      milestones: 'Structure – M3, MEP – M7, Handover – M10',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '15% upfront / 70% milestones / 15% completion',
      contractorName: 'Al-Fahad Contracting',
      submittedDate: DateTime(2026, 7, 18),
      guaranteeRowText: 'Active · TRV-GT-77104',
    ),
  ];
}
