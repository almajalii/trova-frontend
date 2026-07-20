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
//     "claimDate": null
//   }
// }
//
// POST /api/guarantees/{guaranteeId}/approve  → same shape, status ACTIVE
// POST /api/guarantees/{guaranteeId}/reject   → same shape, status REJECTED
//
// This is the owner-side read/approve/reject flow only — the contractor's
// bank-application flow lives in a separate part of the app (not this
// codebase). `status` drives which screen state renders: PENDING_REVIEW →
// Review Guarantee screen; ACTIVE → Guarantee Document (verified/green);
// CLAIMED → Guarantee Document (claimed/red, uses claimDate instead of
// validUntil); REJECTED is terminal for this guarantee (contractor must
// submit a new one, which comes back as a fresh PENDING_REVIEW record).
// ───────────────────────────────────────────────────────────────────────

enum OwnerGuaranteeStatus { pendingReview, active, rejected, claimed }

extension OwnerGuaranteeStatusX on OwnerGuaranteeStatus {
  String get apiValue {
    switch (this) {
      case OwnerGuaranteeStatus.pendingReview:
        return 'PENDING_REVIEW';
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
  final String beneficiary; // owner's company name, "... (You)"
  final String issuingBank;
  final double amountJod;
  final String type; // e.g. "Performance Guarantee"
  final OwnerGuaranteeStatus status;
  final DateTime? issueDate;
  final DateTime? validUntil;
  final DateTime? claimDate; // set instead of validUntil once claimed

  const OwnerGuarantee({
    required this.guaranteeId,
    required this.projectId,
    required this.projectTitle,
    required this.contractorName,
    required this.beneficiary,
    required this.issuingBank,
    required this.amountJod,
    required this.type,
    required this.status,
    this.issueDate,
    this.validUntil,
    this.claimDate,
  });

  /// First letter of each word in the bank name, e.g. "Arab Bank" -> "AB".
  String get bankInitials {
    final words = issuingBank.trim().split(RegExp(r'\s+'));
    return words.map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();
  }

  OwnerGuarantee copyWith({OwnerGuaranteeStatus? status}) => OwnerGuarantee(
    guaranteeId: guaranteeId,
    projectId: projectId,
    projectTitle: projectTitle,
    contractorName: contractorName,
    beneficiary: beneficiary,
    issuingBank: issuingBank,
    amountJod: amountJod,
    type: type,
    status: status ?? this.status,
    issueDate: issueDate,
    validUntil: validUntil,
    claimDate: claimDate,
  );

  factory OwnerGuarantee.fromJson(Map<String, dynamic> json) => OwnerGuarantee(
    guaranteeId: json['guaranteeId'] as String,
    projectId: json['projectId'] as String,
    projectTitle: json['projectTitle'] as String,
    contractorName: json['contractorName'] as String,
    beneficiary: json['beneficiary'] as String,
    issuingBank: json['issuingBank'] as String,
    amountJod: (json['amountJod'] as num).toDouble(),
    type: json['type'] as String,
    status: OwnerGuaranteeStatusX.fromApiValue(json['status'] as String),
    issueDate: json['issueDate'] != null ? DateTime.parse(json['issueDate'] as String) : null,
    validUntil: json['validUntil'] != null ? DateTime.parse(json['validUntil'] as String) : null,
    claimDate: json['claimDate'] != null ? DateTime.parse(json['claimDate'] as String) : null,
  );

  /// Demo data matching the three example guarantees on the Figma frames —
  /// one of each status worth showing (pending review, active/verified,
  /// claimed). Keyed to the same project ids used in project-detail's
  /// demoList() so navigating there feels connected.
  static List<OwnerGuarantee> demoList() => [
    OwnerGuarantee(
      guaranteeId: 'TRV-GT-88213',
      projectId: 'TRV-PRJ-40218',
      projectTitle: 'Al-Noor Tower',
      contractorName: 'Al-Fahad Contracting',
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
      beneficiary: 'You',
      issuingBank: 'Housing Bank',
      amountJod: 3400,
      type: 'Performance Guarantee',
      status: OwnerGuaranteeStatus.claimed,
      issueDate: DateTime(2026, 3, 12),
      claimDate: DateTime(2026, 5, 10),
    ),
  ];
}
