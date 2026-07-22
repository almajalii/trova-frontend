class BidHistoryModel {
  final String id;
  final String projectTitle;
  final String companyName;
  final double bidAmount;
  final String status; // 'completed' | 'rejected' | 'backedOff'
  final String? note;
  final int? reviewRating; // 1..5, only for completed bids with a review
  final String? reviewText;

  const BidHistoryModel({
    required this.id,
    required this.projectTitle,
    required this.companyName,
    required this.bidAmount,
    required this.status,
    this.note,
    this.reviewRating,
    this.reviewText,
  });

  factory BidHistoryModel.fromJson(Map<String, dynamic> json) {
    return BidHistoryModel(
      id: json['bidId'] as String,
      projectTitle: json['projectTitle'] as String,
      companyName: json['companyName'] as String,
      bidAmount: (json['bidAmountJod'] as num).toDouble(),
      status: _statusFromApi(json['status'] as String),
      note: json['note'] as String?,
      reviewRating: json['reviewRating'] as int?,
      reviewText: json['reviewText'] as String?,
    );
  }

  /// Backend sends SCREAMING_SNAKE status codes; UI switches on lowerCamel —
  /// same convention as mybid_model.dart.
  static String _statusFromApi(String raw) {
    switch (raw) {
      case 'COMPLETED':
        return 'completed';
      case 'REJECTED':
        return 'rejected';
      case 'BACKED_OFF':
        return 'backedOff';
      default:
        return raw;
    }
  }
}
