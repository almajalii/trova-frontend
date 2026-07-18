// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// Lifecycle after award: pendingRequest -> underBankReview -> issued ->
// (expiring) -> expired. The "Guarantee Verified" screen only appears
// after the bank issues it, so GuaranteeStatus.active is the terminal
// happy-path state modeled here.
//
// POST /api/projects/{projectId}/guarantees
// { "amountJod": 23800, "type": "PERFORMANCE" }   // type: PERFORMANCE | BID | ADVANCE_PAYMENT | MAINTENANCE
//
// Response once issued:
// { "guaranteeId": "TRV-GT-88213", "amountJod": 23800, "type": "PERFORMANCE",
//   "issuingBank": "Arab Bank", "validUntil": "2027-07-10", "status": "ACTIVE" }
// ───────────────────────────────────────────────────────────────────────

enum GuaranteeType { performance, bid, advancePayment, maintenance }

extension GuaranteeTypeX on GuaranteeType {
  String get apiValue {
    switch (this) {
      case GuaranteeType.performance:
        return 'PERFORMANCE';
      case GuaranteeType.bid:
        return 'BID';
      case GuaranteeType.advancePayment:
        return 'ADVANCE_PAYMENT';
      case GuaranteeType.maintenance:
        return 'MAINTENANCE';
    }
  }

  String get label {
    switch (this) {
      case GuaranteeType.performance:
        return 'Performance Guarantee';
      case GuaranteeType.bid:
        return 'Bid Guarantee';
      case GuaranteeType.advancePayment:
        return 'Advance Payment Guarantee';
      case GuaranteeType.maintenance:
        return 'Maintenance Guarantee';
    }
  }
}

class Guarantee {
  final String id;
  final double amountJod;
  final GuaranteeType type;
  final String issuingBank;
  final DateTime validUntil;
  final String status; // ACTIVE | EXPIRING | EXPIRED | PENDING

  const Guarantee({
    required this.id,
    required this.amountJod,
    required this.type,
    required this.issuingBank,
    required this.validUntil,
    required this.status,
  });

  factory Guarantee.fromJson(Map<String, dynamic> json) => Guarantee(
        id: json['guaranteeId'] as String,
        amountJod: (json['amountJod'] as num).toDouble(),
        type: GuaranteeType.values.firstWhere((t) => t.apiValue == json['type']),
        issuingBank: json['issuingBank'] as String,
        validUntil: DateTime.parse(json['validUntil'] as String),
        status: json['status'] as String,
      );
}
