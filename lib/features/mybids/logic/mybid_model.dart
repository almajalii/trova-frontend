class BidModel {
  final String id;
  final String projectTitle;
  final String companyName;
  final double bidAmount;
  final String status; // 'pending' | 'selected' | 'confirmed' | 'inProgress' | 'guaranteeRejected'
  final String note;
  final int? guaranteeExpiresInDays; // only used when status == 'inProgress'

  const BidModel({
    required this.id,
    required this.projectTitle,
    required this.companyName,
    required this.bidAmount,
    required this.status,
    required this.note,
    this.guaranteeExpiresInDays,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'] as String,
      projectTitle: json['projectTitle'] as String,
      companyName: json['companyName'] as String,
      bidAmount: (json['bidAmount'] as num).toDouble(),
      status: json['status'] as String,
      note: json['note'] as String,
      guaranteeExpiresInDays: json['guaranteeExpiresInDays'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectTitle': projectTitle,
      'companyName': companyName,
      'bidAmount': bidAmount,
      'status': status,
      'note': note,
      'guaranteeExpiresInDays': guaranteeExpiresInDays,
    };
  }
}