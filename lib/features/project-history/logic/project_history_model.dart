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
//
// To make the contractor named in `detailText` tappable (opens their bidder
// profile), also include an `awardedBidder` object shaped like the Compare
// Scores bid entry (see bidder_model.dart) whenever `detailText` names a
// specific contractor — just `bidId`/`companyName` are required:
//   "awardedBidder": { "bidId": "...", "companyName": "Cedar Construction" }
// Omit it when `detailText` doesn't name a bidder (e.g. "Completed May 2026").
// ───────────────────────────────────────────────────────────────────────

import 'package:trova/features/bidders/logic/bidder_model.dart';

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

  /// The contractor named in [detailText], when there is one — lets the UI
  /// make that mention tappable to open the bidder's profile.
  final Bidder? awardedBidder;

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
    this.awardedBidder,
    this.guaranteeStripLabel,
    this.guaranteeStripSubtext,
  });

  factory HistoryProjectSummary.fromJson(Map<String, dynamic> json) => HistoryProjectSummary(
    id: json['projectId'] as String,
    title: json['title'] as String,
    status: HistoryProjectStatusX.fromApiValue(json['status'] as String),
    contractValueJod: (json['contractValueJod'] as num).toDouble(),
    detailText: json['detailText'] as String,
    awardedBidder: Bidder.fromJsonOrNull(json['awardedBidder'] as Map<String, dynamic>?),
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
      awardedBidder: Bidder.contractorRef(bidId: '8f3c2a1b-4d5e-4f60-8a7b-9c0d1e2f3a4b', companyName: 'Cedar Construction', classification: 'C', eligible: false),
      guaranteeStripLabel: 'Flagged: quality concerns',
      guaranteeStripSubtext: 'Under review',
    ),
    HistoryProjectSummary(
      id: 'TRV-PRJ-08821',
      title: 'Old Amman Retail Fitout',
      status: HistoryProjectStatus.failed,
      contractValueJod: 34000,
      detailText: 'Contractor: Al-Manara Group',
      awardedBidder: Bidder.contractorRef(bidId: '2c7e9f10-3b4a-4d5c-8e6f-1a2b3c4d5e60', companyName: 'Al-Manara Group', classification: 'C', eligible: false),
      guaranteeStripLabel: 'Guarantee: Claimed',
      guaranteeStripSubtext: 'Contract not fulfilled',
    ),
  ];
}
