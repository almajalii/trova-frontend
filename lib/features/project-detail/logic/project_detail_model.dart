// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/{projectId}  (Bearer auth — owner viewing their own
// project's detail; works for both active projects and history entries,
// since it's the same screen either way)
// {
//   "data": {
//     "projectId": "TRV-PRJ-60214",
//     "title": "Wadi Al-Seer Warehouse",
//     "status": "IN_PROGRESS",
//     "statusLabel": "In Progress",
//     "subtitle": "Awarded to Horizon Engineering",
//     "sector": "Industrial",
//     "contractValueJod": 95000,
//     "location": "Wadi Al-Seer, Amman",
//     "timelineText": "8 months (Jul 2026 – Feb 2027)",
//     "milestones": "Foundation – M2, Structure – M5, Handover – M8",
//     "guaranteeTypeRequired": "Performance Guarantee",
//     "paymentTerms": "20% upfront / 60% milestones / 20% completion",
//     "guaranteeRowText": "Active · Expires Sep 2027",
//     "biddersRowText": null,
//     "guaranteeStatus": "ACTIVE",
//     "timeline": [
//       { "label": "Posted", "date": "2026-06-28", "state": "DONE" },
//       { "label": "Awarded (Contract Signed)", "date": "2026-07-05", "state": "DONE" },
//       { "label": "Guarantee Active", "date": "2026-07-09", "state": "DONE" },
//       { "label": "In Progress", "date": null, "state": "ACTIVE" },
//       { "label": "Pending Review → Completed", "date": null, "state": "UPCOMING" }
//     ],
//     "actionLabel": null,
//     "actionIsDanger": false
//   }
// }
//
// `status` drives the badge tone only; `statusLabel` is the exact copy
// shown (it can differ slightly from the My Projects list card's badge —
// e.g. "Guarantee Rejected" here vs "Guarantee Rejected by You" on the
// list card — so it's sent/stored as its own field rather than derived).
// `timeline[].state` is one of DONE | ACTIVE | UPCOMING | FAILED — see
// DetailStepState below for what each renders as.
// `guaranteeStatus` (PENDING_REVIEW | ISSUED | ACTIVE | REJECTED | CLAIMED |
// null) is the same enum as OwnerGuaranteeDto.status on the guarantee detail
// endpoint — null exactly when no guarantee application exists yet for this
// project. It's a supplement for client-side branching/logic, not a
// replacement for `guaranteeRowText`, which remains the source of truth for
// what's displayed.
// ───────────────────────────────────────────────────────────────────────
//
// To make the contractor named in `subtitle` tappable (opens their bidder
// profile), the backend should also include an `awardedBidder` object
// shaped like the Compare Scores bid entry (see bidder_model.dart) whenever
// `subtitle` names a specific contractor — just `bidId`/`companyName` are
// required, the rest default to 0/true if omitted:
//   "awardedBidder": { "bidId": "...", "companyName": "Al-Fahad Contracting",
//                       "classification": "A", "eligible": true }
// Omit it (or send null) when the subtitle doesn't name a specific bidder
// (e.g. the "5 contractors have submitted bids" Open for Bids copy).
// ───────────────────────────────────────────────────────────────────────

import 'package:trova/features/bidders/logic/bidder_model.dart';
import 'package:trova/features/guarantee-review/logic/guarantee_review_model.dart';

/// Drives badge tone only (see the widget layer for the actual colors).
/// Covers both the six "My Projects" active statuses and the three
/// "Project History" statuses, since Project Detail is the same screen
/// either way.
enum DetailStatus {
  openForBids,
  awarded,
  contractorBackedOff,
  guaranteeRejectedByYou,
  inProgress,
  pendingReview,
  completed,
  disputed,
  failed,
  cancelled,
}

extension DetailStatusX on DetailStatus {
  String get apiValue {
    switch (this) {
      case DetailStatus.openForBids:
        return 'OPEN_FOR_BIDS';
      case DetailStatus.awarded:
        return 'AWARDED';
      case DetailStatus.contractorBackedOff:
        return 'CONTRACTOR_BACKED_OFF';
      case DetailStatus.guaranteeRejectedByYou:
        return 'GUARANTEE_REJECTED_BY_YOU';
      case DetailStatus.inProgress:
        return 'IN_PROGRESS';
      case DetailStatus.pendingReview:
        return 'PENDING_REVIEW';
      case DetailStatus.completed:
        return 'COMPLETED';
      case DetailStatus.disputed:
        return 'DISPUTED';
      case DetailStatus.failed:
        return 'FAILED';
      case DetailStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static DetailStatus fromApiValue(String value) {
    return DetailStatus.values.firstWhere((s) => s.apiValue == value, orElse: () => DetailStatus.openForBids);
  }
}

/// Visual state of one timeline step.
enum DetailStepState { done, active, upcoming, failed }

extension DetailStepStateX on DetailStepState {
  static DetailStepState fromApiValue(String value) {
    switch (value) {
      case 'DONE':
        return DetailStepState.done;
      case 'ACTIVE':
        return DetailStepState.active;
      case 'FAILED':
        return DetailStepState.failed;
      default:
        return DetailStepState.upcoming;
    }
  }
}

class DetailTimelineStep {
  final String label;
  final String? date;
  final DetailStepState state;

  const DetailTimelineStep({required this.label, this.date, required this.state});

  factory DetailTimelineStep.fromJson(Map<String, dynamic> json) => DetailTimelineStep(
    label: json['label'] as String,
    date: json['date'] as String?,
    state: DetailStepStateX.fromApiValue(json['state'] as String),
  );
}

class ProjectDetail {
  final String id;
  final String title;
  final DetailStatus status;
  final String statusLabel;
  final String? subtitle;

  /// The contractor named in [subtitle], when there is one — lets the UI
  /// make that mention tappable to open the bidder's profile. Null when
  /// [subtitle] doesn't name a specific contractor (e.g. Open for Bids).
  final Bidder? awardedBidder;

  final String sector;
  final double contractValueJod;
  final String location;
  final String timelineText; // duration, e.g. "8 months (Jul 2026 – Feb 2027)"
  final String? milestones;
  final String guaranteeTypeRequired;
  final String paymentTerms;
  final String projectId; // display code, e.g. "TRV-PRJ-60214"
  final String? guaranteeRowText;
  final String? biddersRowText;

  /// Same enum as OwnerGuaranteeDto.status (GET /projects/{id}/guarantee).
  /// Null whenever no GuaranteeApplication exists yet for this project —
  /// not gated on [status]. Supplements [guaranteeRowText] for
  /// branching/logic; the row text remains the source of truth for display
  /// copy.
  final OwnerGuaranteeStatus? guaranteeStatus;

  final List<DetailTimelineStep> timeline;

  final String? actionLabel;
  final bool actionIsDanger;

  const ProjectDetail({
    required this.id,
    required this.title,
    required this.status,
    required this.statusLabel,
    this.subtitle,
    this.awardedBidder,
    required this.sector,
    required this.contractValueJod,
    required this.location,
    required this.timelineText,
    this.milestones,
    required this.guaranteeTypeRequired,
    required this.paymentTerms,
    required this.projectId,
    this.guaranteeRowText,
    this.biddersRowText,
    this.guaranteeStatus,
    required this.timeline,
    this.actionLabel,
    this.actionIsDanger = false,
  });

  factory ProjectDetail.fromJson(Map<String, dynamic> json) => ProjectDetail(
    id: json['projectId'] as String,
    title: json['title'] as String,
    status: DetailStatusX.fromApiValue(json['status'] as String),
    statusLabel: json['statusLabel'] as String,
    subtitle: json['subtitle'] as String?,
    awardedBidder: Bidder.fromJsonOrNull(json['awardedBidder'] as Map<String, dynamic>?),
    sector: json['sector'] as String,
    contractValueJod: (json['contractValueJod'] as num).toDouble(),
    location: json['location'] as String,
    timelineText: json['timelineText'] as String,
    milestones: json['milestones'] as String?,
    guaranteeTypeRequired: json['guaranteeTypeRequired'] as String,
    paymentTerms: json['paymentTerms'] as String,
    projectId: json['projectId'] as String,
    guaranteeRowText: json['guaranteeRowText'] as String?,
    biddersRowText: json['biddersRowText'] as String?,
    guaranteeStatus: json['guaranteeStatus'] != null
        ? OwnerGuaranteeStatusX.fromApiValue(json['guaranteeStatus'] as String)
        : null,
    timeline: (json['timeline'] as List).map((e) => DetailTimelineStep.fromJson(e as Map<String, dynamic>)).toList(),
    actionLabel: json['actionLabel'] as String?,
    actionIsDanger: json['actionIsDanger'] as bool? ?? false,
  );

  /// Demo data matching all nine Project Detail variants on the Figma
  /// frame — six active statuses plus the three reachable from Project
  /// History. Used while kUseMockProjectDetail is true.
  static List<ProjectDetail> demoList() => const [
    ProjectDetail(
      id: 'TRV-PRJ-88104',
      title: 'Riverside Complex Phase 2',
      status: DetailStatus.openForBids,
      statusLabel: 'Open for Bids',
      subtitle: '5 contractors have submitted bids. Compare their scores to choose one.',
      sector: 'Real Estate',
      contractValueJod: 1200000,
      location: 'Riverside, Amman',
      timelineText: '18 months (planned)',
      milestones: 'Phase 1 – M6, Phase 2 – M12, Handover – M18',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '10% upfront / 80% milestones / 10% completion',
      projectId: 'TRV-PRJ-88104',
      biddersRowText: '5 submitted',
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Jul 8, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Bids Received', date: '5 so far', state: DetailStepState.active),
        DetailTimelineStep(label: 'Awarded', state: DetailStepState.upcoming),
        DetailTimelineStep(label: 'Guarantee Active → In Progress', state: DetailStepState.upcoming),
      ],
      actionLabel: 'View Bidders',
    ),
    ProjectDetail(
      id: 'TRV-PRJ-40218',
      title: 'Al-Noor Tower Construction',
      status: DetailStatus.awarded,
      statusLabel: 'Awarded',
      subtitle: 'Contract signed with Al-Fahad Contracting. Their bank guarantee is being processed.',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      sector: 'Construction',
      contractValueJod: 240000,
      location: 'Abdali, Amman',
      timelineText: '14 months (Aug 2026 – Oct 2027)',
      milestones: 'Foundation – M2, Structure – M8, Handover – M14',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      projectId: 'TRV-PRJ-40218',
      guaranteeRowText: 'Pending Bank Approval',
      guaranteeStatus: OwnerGuaranteeStatus.pendingReview,
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Jun 30, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'Jul 12, 2026', state: DetailStepState.active),
        DetailTimelineStep(label: 'Guarantee Active', state: DetailStepState.upcoming),
        DetailTimelineStep(label: 'In Progress', state: DetailStepState.upcoming),
        DetailTimelineStep(label: 'Pending Review → Completed', state: DetailStepState.upcoming),
      ],
    ),
    ProjectDetail(
      id: 'TRV-PRJ-60214',
      title: 'Wadi Al-Seer Warehouse',
      status: DetailStatus.inProgress,
      statusLabel: 'In Progress',
      subtitle: 'Awarded to Horizon Engineering',
      awardedBidder: Bidder.contractorRef(bidId: 'd4a9f712-55e3-4b8a-9c60-1a2b3c4d5e6f', companyName: 'Horizon Engineering'),
      sector: 'Industrial',
      contractValueJod: 95000,
      location: 'Wadi Al-Seer, Amman',
      timelineText: '8 months (Jul 2026 – Feb 2027)',
      milestones: 'Foundation – M2, Structure – M5, Handover – M8',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      projectId: 'TRV-PRJ-60214',
      guaranteeRowText: 'Active · Expires Sep 2027',
      guaranteeStatus: OwnerGuaranteeStatus.active,
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Jun 28, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'Jul 5, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Guarantee Active', date: 'Jul 9, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'In Progress', state: DetailStepState.active),
        DetailTimelineStep(label: 'Pending Review → Completed', state: DetailStepState.upcoming),
      ],
    ),
    ProjectDetail(
      id: 'TRV-PRJ-33871',
      title: 'Al-Salam Mall',
      status: DetailStatus.pendingReview,
      statusLabel: 'Pending Review',
      subtitle: "Al-Fahad Contracting has marked this project as complete and it now needs your review.",
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      sector: 'Real Estate',
      contractValueJod: 152000,
      location: 'Al-Salam, Amman',
      timelineText: '10 months (Jun 2026 – Apr 2027)',
      milestones: 'Structure – M3, MEP – M7, Handover – M10',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '15% upfront / 70% milestones / 15% completion',
      projectId: 'TRV-PRJ-33871',
      guaranteeRowText: 'Active · TRV-GT-77104',
      guaranteeStatus: OwnerGuaranteeStatus.active,
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Jun 20, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'Jun 25, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Guarantee Active', date: 'Jun 29, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'In Progress', date: 'Jul 1, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Pending Review', state: DetailStepState.active),
        DetailTimelineStep(label: 'Completed', state: DetailStepState.upcoming),
      ],
      actionLabel: 'Review Work',
    ),
    ProjectDetail(
      id: 'TRV-PRJ-71205',
      title: 'Zaytoonah Textile Plant',
      status: DetailStatus.contractorBackedOff,
      statusLabel: 'Contractor Backed Off',
      subtitle: 'Al-Fahad Contracting withdrew after being selected. Update your details and post again.',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      sector: 'Industrial',
      contractValueJod: 71000,
      location: 'Sahab Industrial Zone, Amman',
      timelineText: '6 months (planned)',
      milestones: 'Fit-out – M3, Handover – M6',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      projectId: 'TRV-PRJ-71205',
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Jun 18, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Selected Al-Fahad Contracting', date: 'Jun 24, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Contractor Backed Off', date: 'Jun 26, 2026', state: DetailStepState.failed),
      ],
      actionLabel: 'Post Project Again',
    ),
    ProjectDetail(
      id: 'TRV-PRJ-91027',
      title: 'Sahab Business Center',
      status: DetailStatus.guaranteeRejectedByYou,
      statusLabel: 'Guarantee Rejected',
      subtitle: 'Awarded to Al-Manara Group',
      awardedBidder: Bidder.contractorRef(bidId: '2c7e9f10-3b4a-4d5c-8e6f-1a2b3c4d5e60', companyName: 'Al-Manara Group', classification: 'C', eligible: false),
      sector: 'Industrial',
      contractValueJod: 44000,
      location: 'Sahab, Amman',
      timelineText: '5 months (planned)',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      projectId: 'TRV-PRJ-91027',
      guaranteeStatus: OwnerGuaranteeStatus.rejected,
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Jun 10, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'Jun 18, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Guarantee Issued by Bank', date: 'Jun 24, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'You Rejected Guarantee', date: 'Jun 25, 2026', state: DetailStepState.failed),
        DetailTimelineStep(label: 'Awaiting Contractor Response', state: DetailStepState.upcoming),
      ],
      actionLabel: 'Post Project Again',
    ),
    ProjectDetail(
      id: 'TRV-PRJ-19042',
      title: 'Downtown Office Renovation',
      status: DetailStatus.completed,
      statusLabel: 'Completed',
      subtitle: 'Project completed successfully by Zaytoonah Group. You left a 4.8-star review.',
      awardedBidder: Bidder.contractorRef(bidId: 'a1b2c3d4-5e6f-4a7b-8c9d-0e1f2a3b4c5d', companyName: 'Zaytoonah Group'),
      sector: 'Renovation & Fit-out',
      contractValueJod: 85000,
      location: 'Downtown, Amman',
      timelineText: '4 months (Feb 2026 – May 2026)',
      milestones: 'Demo – M1, Fit-out – M3, Handover – M4',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '25% upfront / 50% milestones / 25% completion',
      projectId: 'TRV-PRJ-19042',
      guaranteeRowText: 'Expired · No claims',
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Feb 2, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'Feb 10, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Guarantee Active', date: 'Feb 14, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'In Progress', date: 'Feb 18, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Pending Review', date: 'May 20, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Completed', date: 'May 24, 2026', state: DetailStepState.done),
      ],
    ),
    ProjectDetail(
      id: 'TRV-PRJ-55290',
      title: 'Marka Logistics Center',
      status: DetailStatus.disputed,
      statusLabel: 'Disputed',
      // Matches the real endpoint's format now that it sends the actual
      // flagged reason here instead of generic "under review" copy.
      subtitle: "You flagged this project's submitted work: quality concerns with the completed work.",
      awardedBidder: Bidder.contractorRef(bidId: '8f3c2a1b-4d5e-4f60-8a7b-9c0d1e2f3a4b', companyName: 'Cedar Construction', classification: 'C', eligible: false),
      sector: 'Industrial',
      contractValueJod: 62000,
      location: 'Marka, Amman',
      timelineText: '5 months (May 2026 – Sep 2026)',
      milestones: 'Structure – M2, MEP – M4, Handover – M5',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '20% upfront / 60% milestones / 20% completion',
      projectId: 'TRV-PRJ-55290',
      guaranteeRowText: 'Active · Held pending dispute',
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'May 5, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'May 12, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Guarantee Active', date: 'May 16, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'In Progress', date: 'May 20, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Pending Review', date: 'Jul 2, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Disputed', date: 'Jul 4, 2026', state: DetailStepState.failed),
      ],
      actionLabel: 'View Dispute Status',
    ),
    // NOTE: the backend never actually produces DetailStatus.failed today —
    // every dispute resolution (favorable or not) lands on `completed`,
    // distinguished only by `subtitle`/`timeline` copy ("Dispute resolved:
    // ..."). This entry (and the failed-status UI it exercises) is kept for
    // whenever the backend adds a real "resolved against the owner, guarantee
    // claimed" outcome, but isn't reachable from live data right now — not
    // worth polishing further until that exists.
    ProjectDetail(
      id: 'TRV-PRJ-08821',
      title: 'Old Amman Retail Fitout',
      status: DetailStatus.failed,
      statusLabel: 'Failed',
      subtitle: 'The dispute was resolved against Al-Manara Group. The bank guarantee was claimed on your behalf.',
      awardedBidder: Bidder.contractorRef(bidId: '2c7e9f10-3b4a-4d5c-8e6f-1a2b3c4d5e60', companyName: 'Al-Manara Group', classification: 'C', eligible: false),
      sector: 'Renovation & Fit-out',
      contractValueJod: 34000,
      location: 'Old Amman, Amman',
      timelineText: '3 months (Mar 2026 – May 2026)',
      milestones: 'Demo – M1, Fit-out – M2, Handover – M3',
      guaranteeTypeRequired: 'Performance Guarantee',
      paymentTerms: '30% upfront / 50% milestones / 20% completion',
      projectId: 'TRV-PRJ-08821',
      guaranteeRowText: 'Claimed · JOD 3,400 recovered',
      guaranteeStatus: OwnerGuaranteeStatus.claimed,
      timeline: [
        DetailTimelineStep(label: 'Posted', date: 'Mar 1, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Awarded (Contract Signed)', date: 'Mar 8, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Guarantee Active', date: 'Mar 12, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'In Progress', date: 'Mar 16, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Disputed', date: 'Apr 28, 2026', state: DetailStepState.done),
        DetailTimelineStep(label: 'Failed · Guarantee Claimed', date: 'May 10, 2026', state: DetailStepState.failed),
      ],
      actionLabel: 'View Guarantee Claim',
      actionIsDanger: true,
    ),
  ];
}
