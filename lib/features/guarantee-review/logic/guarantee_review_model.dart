// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/projects/{projectId}/guarantee  (Bearer auth — owner side)
// {
//   "data": {
//     "guaranteeId": "TRV-GT-88213",
//     "projectId": "TRV-PRJ-40218",
//     "projectTitle": "Al-Noor Tower Construction",
//     "contractorName": "Al-Fahad Contracting",
//     "beneficiary": "Wadi Al-Seer Holdings (You)",
//     "issuingBank": "Arab Bank",
//     "amountJod": 23800,
//     "type": "Performance Guarantee",
//     "status": "PENDING_REVIEW",
//     "issueDate": null,
//     "validUntil": "2027-07-10",
//     "claimDate": null,
//     "rejectionReason": null
//   }
// }
//
// POST /api/projects/{projectId}/guarantee/confirm → same shape, status ACTIVE
// POST /api/projects/{projectId}/guarantee/reject  → body { "reason": string | null },
//                                                      same shape, status REJECTED
//
// These two are owner-only now (bank has its own issue/reject endpoints on
// a separate applicationCode-keyed path, not this codebase's concern). The
// flow is two decisions, not one:
//   PENDING_REVIEW  (bank hasn't decided — owner has nothing to do yet)
//         → [bank issues]   → ISSUED   (owner's turn: confirm/reject)
//         → [owner confirms] → ACTIVE  (bid/project flip to InProgress)
// `status` drives which screen state renders: PENDING_REVIEW → Review
// Guarantee screen, read-only (no confirm/reject — bank hasn't decided);
// ISSUED → Review Guarantee screen with confirm/reject actions; ACTIVE →
// Guarantee Document (verified/green); CLAIMED → Guarantee Document
// (claimed/red, uses claimDate instead of validUntil); REJECTED is terminal
// for this guarantee (contractor must submit a new one, which comes back as
// a fresh PENDING_REVIEW record). `issueDate` populates as soon as the bank
// issues it, so it's present during ISSUED too, not just ACTIVE.
// `rejectionReason` is populated whenever status == REJECTED — always if
// the bank rejected it, possibly null if the owner rejected it without
// leaving a note.
//
// To make `contractorName` tappable (opens their bidder profile), also
// include an `awardedBidder` object shaped like the Compare Scores bid
// entry (see bidder_model.dart) — just `bidId`/`companyName` are required:
//   "awardedBidder": { "bidId": "...", "companyName": "Al-Fahad Contracting" }
// ───────────────────────────────────────────────────────────────────────

import 'package:trova/features/bidders/logic/bidder_model.dart';

enum OwnerGuaranteeStatus { pendingReview, issued, active, rejected, claimed }

extension OwnerGuaranteeStatusX on OwnerGuaranteeStatus {
  String get apiValue {
    switch (this) {
      case OwnerGuaranteeStatus.pendingReview:
        return 'PENDING_REVIEW';
      case OwnerGuaranteeStatus.issued:
        return 'ISSUED';
      case OwnerGuaranteeStatus.active:
        return 'ACTIVE';
      case OwnerGuaranteeStatus.rejected:
        return 'REJECTED';
      case OwnerGuaranteeStatus.claimed:
        return 'CLAIMED';
    }
  }

  static OwnerGuaranteeStatus fromApiValue(String value) {
    switch (value) {
      case 'ISSUED':
        return OwnerGuaranteeStatus.issued;
      case 'ACTIVE':
        return OwnerGuaranteeStatus.active;
      case 'REJECTED':
        return OwnerGuaranteeStatus.rejected;
      case 'CLAIMED':
        return OwnerGuaranteeStatus.claimed;
      default:
        return OwnerGuaranteeStatus.pendingReview;
    }
  }
}

class OwnerGuarantee {
  final String guaranteeId;
  final String projectId;
  final String projectTitle;
  final String contractorName; // "Principal" on the document
  final Bidder? awardedBidder;
  final String beneficiary; // owner's company name, "... (You)"
  final String issuingBank;
  final double amountJod;
  final String type; // e.g. "Performance Guarantee"
  final OwnerGuaranteeStatus status;
  final DateTime? issueDate;
  final DateTime? validUntil;
  final DateTime? claimDate; // set instead of validUntil once claimed
  final String? rejectionReason; // populated when status == rejected

  const OwnerGuarantee({
    required this.guaranteeId,
    required this.projectId,
    required this.projectTitle,
    required this.contractorName,
    this.awardedBidder,
    required this.beneficiary,
    required this.issuingBank,
    required this.amountJod,
    required this.type,
    required this.status,
    this.issueDate,
    this.validUntil,
    this.claimDate,
    this.rejectionReason,
  });

  /// First letter of each word in the bank name, e.g. "Arab Bank" -> "AB".
  String get bankInitials {
    final words = issuingBank.trim().split(RegExp(r'\s+'));
    return words.map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  OwnerGuarantee copyWith({OwnerGuaranteeStatus? status, String? rejectionReason}) => OwnerGuarantee(
    guaranteeId: guaranteeId,
    projectId: projectId,
    projectTitle: projectTitle,
    contractorName: contractorName,
    awardedBidder: awardedBidder,
    beneficiary: beneficiary,
    issuingBank: issuingBank,
    amountJod: amountJod,
    type: type,
    status: status ?? this.status,
    issueDate: issueDate,
    validUntil: validUntil,
    claimDate: claimDate,
    rejectionReason: rejectionReason ?? this.rejectionReason,
  );

  factory OwnerGuarantee.fromJson(Map<String, dynamic> json) => OwnerGuarantee(
    guaranteeId: json['guaranteeId'] as String,
    projectId: json['projectId'] as String,
    projectTitle: json['projectTitle'] as String,
    contractorName: json['contractorName'] as String,
    awardedBidder: Bidder.fromJsonOrNull(json['awardedBidder'] as Map<String, dynamic>?),
    beneficiary: json['beneficiary'] as String,
    issuingBank: json['issuingBank'] as String,
    amountJod: (json['amountJod'] as num).toDouble(),
    type: json['type'] as String,
    status: OwnerGuaranteeStatusX.fromApiValue(json['status'] as String),
    issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate'] as String) : null,
    validUntil: json['validUntil'] != null ? DateTime.parse(json['validUntil'] as String) : null,
    claimDate: json['claimDate'] != null ? DateTime.parse(json['claimDate'] as String) : null,
    rejectionReason: json['rejectionReason'] as String?,
  );

  /// Demo data matching the example guarantees on the Figma frames — one of
  /// each status worth showing (pending review, active/verified, claimed).
  /// Keyed to the same project ids used in project-detail's demoList() so
  /// navigating there feels connected.
  ///
  /// TRV-PRJ-40218 is PENDING_REVIEW — matches project-detail's demo entry
  /// for the same project ("Their bank guarantee is being processed" /
  /// "Pending Bank Approval"). The bank hasn't decided yet, so this screen
  /// renders read-only; there's currently no demo project wired up for the
  /// ISSUED (confirm/reject) state — add one if you need to exercise that
  /// flow against mock data.
  static List<OwnerGuarantee> demoList() => [
    OwnerGuarantee(
      guaranteeId: 'TRV-GT-88213',
      projectId: 'TRV-PRJ-40218',
      projectTitle: 'Al-Noor Tower',
      contractorName: 'Al-Fahad Contracting',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      beneficiary: 'You',
      issuingBank: 'Arab Bank',
      amountJod: 23800,
      type: 'Performance Guarantee',
      status: OwnerGuaranteeStatus.pendingReview,
      validUntil: DateTime(2027, 7, 10),
    ),
    OwnerGuarantee(
      guaranteeId: 'TRV-GT-60214',
      projectId: 'TRV-PRJ-60214',
      projectTitle: 'Wadi Al-Seer Warehouse',
      contractorName: 'Horizon Engineering',
      awardedBidder: Bidder.contractorRef(bidId: 'd4a9f712-55e3-4b8a-9c60-1a2b3c4d5e6f', companyName: 'Horizon Engineering'),
      beneficiary: 'Wadi Al-Seer Holdings (You)',
      issuingBank: 'Arab Bank',
      amountJod: 9500,
      type: 'Performance Guarantee',
      status: OwnerGuaranteeStatus.active,
      issueDate: DateTime(2026, 7, 9),
      validUntil: DateTime(2027, 9, 9),
    ),
    OwnerGuarantee(
      guaranteeId: 'TRV-GT-65210',
      projectId: 'TRV-PRJ-08821',
      projectTitle: 'Old Amman Retail Fitout',
      contractorName: 'Al-Manara Group',
      awardedBidder: Bidder.contractorRef(bidId: '2c7e9f10-3b4a-4d5c-8e6f-1a2b3c4d5e60', companyName: 'Al-Manara Group', classification: 'C', eligible: false),
      beneficiary: 'You',
      issuingBank: 'Housing Bank',
      amountJod: 3400,
      type: 'Performance Guarantee',
      status: OwnerGuaranteeStatus.claimed,
      issueDate: DateTime(2026, 3, 12),
      claimDate: DateTime(2026, 5, 10),
    ),
    OwnerGuarantee(
      guaranteeId: 'TRV-GT-77104',
      projectId: 'TRV-PRJ-33871',
      projectTitle: 'Al-Salam Mall',
      contractorName: 'Al-Fahad Contracting',
      awardedBidder: Bidder.contractorRef(bidId: '51651ada-1711-4a99-81dc-00c076f726ba', companyName: 'Al-Fahad Contracting'),
      beneficiary: 'You',
      issuingBank: 'Arab Bank',
      amountJod: 22800,
      type: 'Performance Guarantee',
      status: OwnerGuaranteeStatus.active,
      issueDate: DateTime(2026, 6, 29),
      validUntil: DateTime(2027, 4, 30),
    ),
  ];
}
