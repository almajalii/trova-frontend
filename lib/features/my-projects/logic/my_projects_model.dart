// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/mine  (Bearer auth — owner's own posted projects)
// {
//   "data": [
//     {
//       "projectId": "TRV-PRJ-88104",
//       "title": "Riverside Complex Phase 2",
//       "status": "OPEN_FOR_BIDS",
//       "contractValueJod": 1200000,
//       "detailText": "5 bidders",
//       "guaranteeStripLabel": null,
//       "guaranteeStripSubtext": null,
//       "guaranteeStripTone": null,
//       "guaranteeStatus": null,
//       "note": null,
//       "actionLabel": null
//     },
//     {
//       "projectId": "TRV-PRJ-40218",
//       "title": "Al-Noor Tower Construction",
//       "status": "AWARDED",
//       "contractValueJod": 240000,
//       "detailText": "Awarded to Al-Fahad Contracting — guarantee pending bank review",
//       "guaranteeStripLabel": "Guarantee: Pending Bank Review",
//       "guaranteeStripSubtext": "Waiting on bank decision",
//       "guaranteeStripTone": "WARNING",
//       "guaranteeStatus": "PENDING_REVIEW",
//       "note": null,
//       "actionLabel": null
//     }
//   ]
// }
//
// `guaranteeStatus` (PENDING_REVIEW | ISSUED | ACTIVE | REJECTED | CLAIMED |
// null) is the same enum as OwnerGuaranteeDto.status on the guarantee detail
// endpoint — null exactly when no guarantee application exists yet for this
// project (regardless of `status`). It's a supplement for client-side
// branching/logic, not a replacement for the strip text above — the strip
// fields remain the source of truth for what's displayed.
//
// `status` drives badge color + which optional pieces (guarantee strip /
// note / action button) render — see ProjectStatusX below. History-only
// statuses (Completed / Disputed / Failed) live on the separate Project
// History screen, not here.
//
// To make the contractor named in `detailText` tappable (opens their bidder
// profile), also include an `awardedBidder` object shaped like the Compare
// Scores bid entry (see bidder_model.dart) whenever `detailText` names a
// specific contractor — just `bidId`/`companyName` are required:
//   "awardedBidder": { "bidId": "...", "companyName": "Al-Fahad Contracting" }
// Omit it when `detailText` doesn't name a bidder (e.g. "5 bidders").
// ───────────────────────────────────────────────────────────────────────

import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';

enum ProjectStatus { openForBids, awarded, contractorBackedOff, guaranteeRejectedByYou, inProgress, pendingReview }

/// Which section of "My Projects" a status belongs to. Order here also
/// drives the on-screen section order (1. Awaiting Bids, 2. Awarded,
/// 3. In Execution) — numbering is assigned dynamically by the layout so
/// an empty group just doesn't render instead of leaving a gap.
enum ProjectStatusGroup { awaitingBids, awarded, inExecution }

/// Tone for the optional guarantee strip on a card — maps to AppColors'
/// success/warning tokens in the widget layer.
enum GuaranteeStripTone { success, warning }

extension ProjectStatusX on ProjectStatus {
  String get apiValue {
    switch (this) {
      case ProjectStatus.openForBids:
        return 'OPEN_FOR_BIDS';
      case ProjectStatus.awarded:
        return 'AWARDED';
      case ProjectStatus.contractorBackedOff:
        return 'CONTRACTOR_BACKED_OFF';
      case ProjectStatus.guaranteeRejectedByYou:
        return 'GUARANTEE_REJECTED_BY_YOU';
      case ProjectStatus.inProgress:
        return 'IN_PROGRESS';
      case ProjectStatus.pendingReview:
        return 'PENDING_REVIEW';
    }
  }

  static ProjectStatus fromApiValue(String value) {
    return ProjectStatus.values.firstWhere((s) => s.apiValue == value, orElse: () => ProjectStatus.openForBids);
  }

  /// Badge / section label text, matching the Figma copy exactly.
  String get label {
    switch (this) {
      case ProjectStatus.openForBids:
        return 'Open for Bids';
      case ProjectStatus.awarded:
        return 'Awarded';
      case ProjectStatus.contractorBackedOff:
        return 'Contractor Backed Off';
      case ProjectStatus.guaranteeRejectedByYou:
        return 'Guarantee Rejected by You';
      case ProjectStatus.inProgress:
        return 'In Progress';
      case ProjectStatus.pendingReview:
        return 'Pending Review';
    }
  }

  ProjectStatusGroup get group {
    switch (this) {
      case ProjectStatus.openForBids:
        return ProjectStatusGroup.awaitingBids;
      case ProjectStatus.awarded:
      case ProjectStatus.contractorBackedOff:
      case ProjectStatus.guaranteeRejectedByYou:
        return ProjectStatusGroup.awarded;
      case ProjectStatus.inProgress:
      case ProjectStatus.pendingReview:
        return ProjectStatusGroup.inExecution;
    }
  }
}

extension ProjectStatusGroupX on ProjectStatusGroup {
  String get sectionTitle {
    switch (this) {
      case ProjectStatusGroup.awaitingBids:
        return 'AWAITING BIDS';
      case ProjectStatusGroup.awarded:
        return 'AWARDED';
      case ProjectStatusGroup.inExecution:
        return 'IN EXECUTION';
    }
  }
}

class ProjectSummary {
  final String id;
  final String title;
  final ProjectStatus status;
  final double contractValueJod;

  /// Secondary line under the value, e.g. "5 bidders" or
  /// "Awarded to Al-Fahad Contracting".
  final String detailText;

  /// The contractor named in [detailText], when there is one — lets the UI
  /// make that mention tappable to open the bidder's profile.
  final Bidder? awardedBidder;

  /// Optional colored strip (Awarded + In Progress cards only).
  final String? guaranteeStripLabel;
  final String? guaranteeStripSubtext;
  final GuaranteeStripTone? guaranteeStripTone;

  /// Same enum as OwnerGuaranteeDto.status (GET /projects/{id}/guarantee).
  /// Null whenever no GuaranteeApplication exists yet for this project —
  /// not gated on [status], so e.g. an awarded project the contractor
  /// hasn't applied for a guarantee on yet is null here too. Supplements
  /// the strip text above for branching/logic; the strip text remains the
  /// source of truth for display copy.
  final OwnerGuaranteeStatus? guaranteeStatus;

  /// Optional extra note rendered in danger color, e.g. the
  /// "You rejected their guarantee..." line.
  final String? note;

  /// Optional full-width action button label, e.g. "Review Guarantee".
  /// Null means the card has no button (tap still opens project detail).
  final String? actionLabel;

  const ProjectSummary({
    required this.id,
    required this.title,
    required this.status,
    required this.contractValueJod,
    required this.detailText,
    this.awardedBidder,
    this.guaranteeStripLabel,
    this.guaranteeStripSubtext,
    this.guaranteeStripTone,
    this.guaranteeStatus,
    this.note,
    this.actionLabel,
  });

  factory ProjectSummary.fromJson(Map<String, dynamic> json) => ProjectSummary(
    id: json['projectId'] as String,
    title: json['title'] as String,
    status: ProjectStatusX.fromApiValue(json['status'] as String),
    contractValueJod: (json['contractValueJod'] as num).toDouble(),
    detailText: json['detailText'] as String,
    awardedBidder: Bidder.fromJsonOrNull(json['awardedBidder'] as Map<String, dynamic>?),
    guaranteeStripLabel: json['guaranteeStripLabel'] as String?,
    guaranteeStripSubtext: json['guaranteeStripSubtext'] as String?,
    guaranteeStripTone: switch (json['guaranteeStripTone'] as String?) {
      'SUCCESS' => GuaranteeStripTone.success,
      'WARNING' => GuaranteeStripTone.warning,
      _ => null,
    },
    guaranteeStatus: json['guaranteeStatus'] != null
        ? OwnerGuaranteeStatusX.fromApiValue(json['guaranteeStatus'] as String)
        : null,
    note: json['note'] as String?,
    actionLabel: json['actionLabel'] as String?,
  );

  /// Demo data matching the six example cards on the Figma "My Projects"
  /// frame — used while kUseMockMyProjects is true and by the dev screens gallery.
  static List<ProjectSummary> demoList() => const [
    ProjectSummary(
      id: 'TRV-PRJ-88104',
      title: 'Riverside Complex Phase 2',
      status: ProjectStatus.openForBids,
      contractValueJod: 1200000,
      detailText: '5 bidders',
    ),
    ProjectSummary(
      id: 'TRV-PRJ-40218',
      title: 'Al-Noor Tower Construction',
      status: ProjectStatus.awarded,
      contractValueJod: 240000,
      detailText: 'Awarded to Al-Fahad Contracting',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      guaranteeStripLabel: 'Guarantee: Pending Bank Review',
      guaranteeStripSubtext: 'Waiting on bank decision',
      guaranteeStripTone: GuaranteeStripTone.warning,
      guaranteeStatus: OwnerGuaranteeStatus.pendingReview,
    ),
    ProjectSummary(
      id: 'TRV-PRJ-71205',
      title: 'Zaytoonah Textile Plant',
      status: ProjectStatus.contractorBackedOff,
      contractValueJod: 71000,
      detailText: 'Al-Fahad Contracting declined after selection',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      actionLabel: 'Post Project Again',
    ),
    ProjectSummary(
      id: 'TRV-PRJ-91027',
      title: 'Sahab Business Center',
      status: ProjectStatus.guaranteeRejectedByYou,
      contractValueJod: 44000,
      detailText: 'Awarded to Al-Manara Group',
      awardedBidder: Bidder.contractorRef(bidId: '2c7e9f10-3b4a-4d5c-8e6f-1a2b3c4d5e60', companyName: 'Al-Manara Group', classification: 'C', eligible: false),
      note: 'You rejected their guarantee. Waiting for them to resubmit or withdraw.',
      guaranteeStatus: OwnerGuaranteeStatus.rejected,
    ),
    ProjectSummary(
      id: 'TRV-PRJ-60214',
      title: 'Wadi Al-Seer Warehouse',
      status: ProjectStatus.inProgress,
      contractValueJod: 95000,
      detailText: 'Awarded to Horizon Engineering',
      awardedBidder: Bidder.contractorRef(bidId: 'd4a9f712-55e3-4b8a-9c60-1a2b3c4d5e6f', companyName: 'Horizon Engineering'),
      guaranteeStripLabel: 'Guarantee: Active',
      guaranteeStripSubtext: 'Expires Sep 2027',
      guaranteeStripTone: GuaranteeStripTone.success,
      guaranteeStatus: OwnerGuaranteeStatus.active,
    ),
    ProjectSummary(
      id: 'TRV-PRJ-33871',
      title: 'Al-Salam Mall',
      status: ProjectStatus.pendingReview,
      contractValueJod: 152000,
      detailText: 'Marked complete by Al-Fahad Contracting',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      actionLabel: 'Review Work',
    ),
  ];
}
