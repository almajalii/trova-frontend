/// Why the owner landed back on this form. Drives the notice banner copy —
/// see [RepostProjectDraft.noticeMessage].
enum RepostReason {
  contractorBackedOff,
  guaranteeRejectedByOwner;

  factory RepostReason.fromJson(String raw) {
    switch (raw) {
      case 'contractor_backed_off':
        return RepostReason.contractorBackedOff;
      case 'guarantee_rejected_by_owner':
        return RepostReason.guaranteeRejectedByOwner;
      default:
        throw ArgumentError('Unknown RepostReason: $raw');
    }
  }

  String toJson() {
    switch (this) {
      case RepostReason.contractorBackedOff:
        return 'contractor_backed_off';
      case RepostReason.guaranteeRejectedByOwner:
        return 'guarantee_rejected_by_owner';
    }
  }
}

enum ContractorClassification { classA, classB, classC }

extension ContractorClassificationX on ContractorClassification {
  String get apiValue {
    switch (this) {
      case ContractorClassification.classA:
        return 'A';
      case ContractorClassification.classB:
        return 'B';
      case ContractorClassification.classC:
        return 'C';
    }
  }

  String get displayLabel {
    switch (this) {
      case ContractorClassification.classA:
        return 'Class A (High Capacity)';
      case ContractorClassification.classB:
        return 'Class B (Medium Capacity)';
      case ContractorClassification.classC:
        return 'Class C (Standard Capacity)';
    }
  }

  static ContractorClassification fromApiValue(String value) {
    switch (value.trim().toUpperCase()) {
      case 'A':
        return ContractorClassification.classA;
      case 'B':
        return ContractorClassification.classB;
      case 'C':
        return ContractorClassification.classC;
      default:
        // Best-effort fallback for legacy free-text values like
        // "Class B or higher (Medium+)" so old drafts/mock data don't
        // crash on load while the migration is in progress.
        if (value.toUpperCase().contains('A')) return ContractorClassification.classA;
        if (value.toUpperCase().contains('B')) return ContractorClassification.classB;
        return ContractorClassification.classC;
    }
  }
}

/// Prefilled draft shown on the "Edit & Re-post Project" screen.
///
/// This is *not* the same model as whatever `PostAProjectScreen` uses for a
/// brand-new project — it always originates from an existing project
/// (`originalProjectId`), which the service needs to link the repost back to
/// its history for the timeline/audit trail.
class RepostProjectDraft {
  final String originalProjectId;
  final RepostReason reason;

  /// Name of the contractor involved in the backed-off / rejected event.
  /// Used to build [noticeMessage].
  final String contractorName;

  final String title;
  final String sector;
  final double contractValueJod;
  final int minRequiredScore;
  final ContractorClassification minContractorClassification;
  final String description;

  // --- Previously missing fields, now added ---
  final String location;
  final String currency;
  final String timelineText;
  final List<String> milestones;
  final String guaranteeTypeRequired;
  final String paymentTerms;
  final DateTime bidSubmissionDeadline;

  const RepostProjectDraft({
    required this.originalProjectId,
    required this.reason,
    required this.contractorName,
    required this.title,
    required this.sector,
    required this.contractValueJod,
    required this.minRequiredScore,
    required this.minContractorClassification,
    required this.description,
    required this.location,
    required this.currency,
    required this.timelineText,
    required this.milestones,
    required this.guaranteeTypeRequired,
    required this.paymentTerms,
    required this.bidSubmissionDeadline,
  });

  /// Notice banner text shown at the top of the form. Wording depends on
  /// how the owner got here. Computed, not stored — do NOT add this as a
  /// constructor param or copyWith field.
  String get noticeMessage {
    switch (reason) {
      case RepostReason.contractorBackedOff:
        return '$contractorName backed out after being selected. '
            'Your project details are saved below — review or update '
            'anything before posting again.';
      case RepostReason.guaranteeRejectedByOwner:
        return 'You rejected $contractorName\'s guarantee. '
            'Your project details are saved below — review or update '
            'anything before posting again.';
    }
  }

  RepostProjectDraft copyWith({
    String? title,
    String? sector,
    double? contractValueJod,
    int? minRequiredScore,
    ContractorClassification? minContractorClassification,
    String? description,
    String? location,
    String? currency,
    String? timelineText,
    List<String>? milestones,
    String? guaranteeTypeRequired,
    String? paymentTerms,
    DateTime? bidSubmissionDeadline,
  }) {
    return RepostProjectDraft(
      originalProjectId: originalProjectId,
      reason: reason,
      contractorName: contractorName,
      title: title ?? this.title,
      sector: sector ?? this.sector,
      contractValueJod: contractValueJod ?? this.contractValueJod,
      minRequiredScore: minRequiredScore ?? this.minRequiredScore,
      minContractorClassification: minContractorClassification ?? this.minContractorClassification,
      description: description ?? this.description,
      location: location ?? this.location,
      currency: currency ?? this.currency,
      timelineText: timelineText ?? this.timelineText,
      milestones: milestones ?? this.milestones,
      guaranteeTypeRequired: guaranteeTypeRequired ?? this.guaranteeTypeRequired,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      bidSubmissionDeadline: bidSubmissionDeadline ?? this.bidSubmissionDeadline,
    );
  }

  factory RepostProjectDraft.fromJson(Map<String, dynamic> json) {
    return RepostProjectDraft(
      originalProjectId: json['originalProjectId'] as String,
      reason: RepostReason.fromJson(json['reason'] as String),
      contractorName: json['contractorName'] as String,
      title: json['title'] as String,
      sector: json['sector'] as String,
      contractValueJod: (json['contractValueJod'] as num).toDouble(),
      minRequiredScore: json['minRequiredScore'] as int,
      minContractorClassification:
          ContractorClassificationX.fromApiValue(json['minContractorClassification'] as String),
      description: json['description'] as String,
      location: json['location'] as String? ?? '',
      currency: json['currency'] as String? ?? 'JOD',
      timelineText: json['timelineText'] as String? ?? '',
      milestones: (json['milestones'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      guaranteeTypeRequired: json['guaranteeTypeRequired'] as String? ?? '',
      paymentTerms: json['paymentTerms'] as String? ?? '',
      bidSubmissionDeadline: json['bidSubmissionDeadline'] != null
          ? DateTime.parse(json['bidSubmissionDeadline'] as String)
          : DateTime.now().add(const Duration(days: 14)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalProjectId': originalProjectId,
      'reason': reason.toJson(),
      'contractorName': contractorName,
      'title': title,
      'sector': sector,
      'contractValueJod': contractValueJod,
      'minRequiredScore': minRequiredScore,
      'minContractorClassification': minContractorClassification.apiValue,
      'description': description,
      'location': location,
      'currency': currency,
      'timelineText': timelineText,
      'milestones': milestones,
      'guaranteeTypeRequired': guaranteeTypeRequired,
      'paymentTerms': paymentTerms,
      'bidSubmissionDeadline': bidSubmissionDeadline.toIso8601String(),
    };
  }

  /// Mock data for `kUseMockRepostProject` — mirrors the two Project Detail /
  /// My Projects entries that expose "Post Project Again" (Zaytoonah Textile
  /// Plant's contractor backed off; Sahab Business Center's guarantee was
  /// rejected), so `originalProjectId` here matches the ids used there.
  static List<RepostProjectDraft> demoList() {
    return [
      RepostProjectDraft(
        originalProjectId: 'TRV-PRJ-71205',
        reason: RepostReason.contractorBackedOff,
        contractorName: 'Al-Fahad Contracting',
        title: 'Zaytoonah Textile Plant',
        sector: 'Industrial',
        contractValueJod: 71000,
        minRequiredScore: 75,
        minContractorClassification: ContractorClassification.classC,
        description:
            'New textile manufacturing facility fit-out. '
            'Electrical, HVAC, and flooring works. 6-month timeline.',
        location: 'Zarqa, Jordan',
        currency: 'JOD',
        timelineText: '6 months',
        milestones: const ['Site prep & electrical rough-in', 'HVAC install', 'Flooring & handover'],
        guaranteeTypeRequired: 'Performance Guarantee',
        paymentTerms: '30% upfront, 40% at midpoint, 30% on handover',
        bidSubmissionDeadline: DateTime.now().add(const Duration(days: 14)),
      ),
      RepostProjectDraft(
        originalProjectId: 'TRV-PRJ-91027',
        reason: RepostReason.guaranteeRejectedByOwner,
        contractorName: 'Al-Manara Group',
        title: 'Sahab Business Center',
        sector: 'Industrial',
        contractValueJod: 44000,
        minRequiredScore: 70,
        minContractorClassification: ContractorClassification.classB,
        description:
            'New business center construction, 5-month timeline. '
            'Structure, fit-out, and handover milestones.',
        location: 'Sahab, Amman',
        currency: 'JOD',
        timelineText: '5 months',
        milestones: const ['Structure', 'Fit-out', 'Handover'],
        guaranteeTypeRequired: 'Bid Bond',
        paymentTerms: '25% upfront, 50% at midpoint, 25% on handover',
        bidSubmissionDeadline: DateTime.now().add(const Duration(days: 14)),
      ),
    ];
  }
}
