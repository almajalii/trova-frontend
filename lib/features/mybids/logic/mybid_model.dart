class BidModel {
  final String id;
  final String projectId;
  final String projectTitle;
  final String companyName;
  final double bidAmount;
  final String status; // 'pending' | 'selected' | 'confirmed' | 'guaranteePendingReview' | 'guaranteeIssued' | 'guaranteeRejected' | 'inProgress' | 'workSubmitted'
  final String? note;
  final int? guaranteeExpiresInDays; // only used when status == 'inProgress'
  final String? workSubmittedAt; // "yyyy-MM-dd", only set when status == 'workSubmitted'

  const BidModel({
    required this.id,
    required this.projectId,
    required this.projectTitle,
    required this.companyName,
    required this.bidAmount,
    required this.status,
    this.note,
    this.guaranteeExpiresInDays,
    this.workSubmittedAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['bidId'] as String,
      projectId: json['projectId'] as String,
      projectTitle: json['projectTitle'] as String,
      companyName: json['companyName'] as String,
      bidAmount: (json['bidAmountJod'] as num).toDouble(),
      status: _statusFromApi(json['status'] as String),
      note: json['note'] as String?,
      guaranteeExpiresInDays: json['guaranteeExpiresInDays'] as int?,
      workSubmittedAt: json['workSubmittedAt'] as String?,
    );
  }

  /// Backend sends SCREAMING_SNAKE status codes; the UI (mybids_card.dart)
  /// switches on lowerCamel values, so map explicitly. Unknown codes pass
  /// through as-is and fall into the UI's default branches instead of
  /// crashing.
  static String _statusFromApi(String raw) {
    switch (raw) {
      case 'PENDING':
        return 'pending';
      case 'SELECTED':
        return 'selected';
      case 'CONFIRMED':
        return 'confirmed';
      case 'GUARANTEE_PENDING_REVIEW':
        return 'guaranteePendingReview';
      case 'GUARANTEE_ISSUED':
        return 'guaranteeIssued';
      case 'GUARANTEE_REJECTED':
        return 'guaranteeRejected';
      case 'IN_PROGRESS':
        return 'inProgress';
      case 'WORK_SUBMITTED':
        return 'workSubmitted';
      default:
        return raw;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'projectTitle': projectTitle,
      'companyName': companyName,
      'bidAmount': bidAmount,
      'status': status,
      'note': note,
      'guaranteeExpiresInDays': guaranteeExpiresInDays,
      'workSubmittedAt': workSubmittedAt,
    };
  }
}
