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
  final String minContractorClassification;
  final String description;

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
  });

  /// Notice banner text shown at the top of the form. Wording depends on
  /// how the owner got here.
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
    String? minContractorClassification,
    String? description,
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
      minContractorClassification: json['minContractorClassification'] as String,
      description: json['description'] as String,
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
      'minContractorClassification': minContractorClassification,
      'description': description,
    };
  }

  /// Mock data for `kUseMockData` — mirrors the two Project Detail / My
  /// Projects entries that expose "Post Project Again" (Zaytoonah Textile
  /// Plant's contractor backed off; Sahab Business Center's guarantee was
  /// rejected), so `originalProjectId` here matches the ids used there.
  static List<RepostProjectDraft> demoList() {
    return [
      const RepostProjectDraft(
        originalProjectId: 'TRV-PRJ-71205',
        reason: RepostReason.contractorBackedOff,
        contractorName: 'Al-Fahad Contracting',
        title: 'Zaytoonah Textile Plant',
        sector: 'Industrial',
        contractValueJod: 71000,
        minRequiredScore: 75,
        minContractorClassification: 'Class C or higher (Small+)',
        description:
            'New textile manufacturing facility fit-out. '
            'Electrical, HVAC, and flooring works. 6-month timeline.',
      ),
      const RepostProjectDraft(
        originalProjectId: 'TRV-PRJ-91027',
        reason: RepostReason.guaranteeRejectedByOwner,
        contractorName: 'Al-Manara Group',
        title: 'Sahab Business Center',
        sector: 'Industrial',
        contractValueJod: 44000,
        minRequiredScore: 70,
        minContractorClassification: 'Class B or higher (Medium+)',
        description:
            'New business center construction, 5-month timeline. '
            'Structure, fit-out, and handover milestones.',
      ),
    ];
  }
}
