// lib/features/biddetail/logic/bid_detail_model.dart

enum BidStepState { completed, current, rejected, pending }

class StatusStepModel {
  final String label;
  final String? date;
  final BidStepState state;

  const StatusStepModel({
    required this.label,
    this.date,
    required this.state,
  });

  factory StatusStepModel.fromJson(Map<String, dynamic> json) {
    return StatusStepModel(
      label: json['label'] as String,
      date: json['date'] as String?,
      state: BidStepState.values.firstWhere(
        (e) => e.name == json['state'],
        orElse: () => BidStepState.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'date': date,
        'state': state.name,
      };
}

class BidDetailModel {
  final String id;
  final String projectTitle;
  final String companyName;
  final String status; // 'pending' | 'selected' | 'confirmed' | 'inProgress' | 'guaranteeRejected' | 'rejected'
  final String sector;
  final String location;
  final double contractValue;
  final String timelineRange;
  final double bidAmount;
  final String projectId;
  final List<StatusStepModel> statusSteps;

  // Optional, only present for some statuses
  final String? milestones;
  final String? guaranteeTypeRequired;
  final String? paymentTerms;
  final String? description;
  final int? guaranteeExpiresInDays;
  final String? bannerNote; // rejection / guarantee-rejected explanation text

  const BidDetailModel({
    required this.id,
    required this.projectTitle,
    required this.companyName,
    required this.status,
    required this.sector,
    required this.location,
    required this.contractValue,
    required this.timelineRange,
    required this.bidAmount,
    required this.projectId,
    required this.statusSteps,
    this.milestones,
    this.guaranteeTypeRequired,
    this.paymentTerms,
    this.description,
    this.guaranteeExpiresInDays,
    this.bannerNote,
  });

  factory BidDetailModel.fromJson(Map<String, dynamic> json) {
    return BidDetailModel(
      id: json['id'] as String,
      projectTitle: json['projectTitle'] as String,
      companyName: json['companyName'] as String,
      status: json['status'] as String,
      sector: json['sector'] as String,
      location: json['location'] as String,
      contractValue: (json['contractValue'] as num).toDouble(),
      timelineRange: json['timelineRange'] as String,
      bidAmount: (json['bidAmount'] as num).toDouble(),
      projectId: json['projectId'] as String,
      statusSteps: (json['statusSteps'] as List)
          .map((e) => StatusStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      milestones: json['milestones'] as String?,
      guaranteeTypeRequired: json['guaranteeTypeRequired'] as String?,
      paymentTerms: json['paymentTerms'] as String?,
      description: json['description'] as String?,
      guaranteeExpiresInDays: json['guaranteeExpiresInDays'] as int?,
      bannerNote: json['bannerNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectTitle': projectTitle,
        'companyName': companyName,
        'status': status,
        'sector': sector,
        'location': location,
        'contractValue': contractValue,
        'timelineRange': timelineRange,
        'bidAmount': bidAmount,
        'projectId': projectId,
        'statusSteps': statusSteps.map((e) => e.toJson()).toList(),
        'milestones': milestones,
        'guaranteeTypeRequired': guaranteeTypeRequired,
        'paymentTerms': paymentTerms,
        'description': description,
        'guaranteeExpiresInDays': guaranteeExpiresInDays,
        'bannerNote': bannerNote,
      };
}