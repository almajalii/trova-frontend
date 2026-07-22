class Project {
  final String projectId;
  final String title;
  final String postedByCompanyName;
  final String sector;
  final String location;
  final double contractValueJod;
  final String timelineText;
  final String milestones;
  final String guaranteeTypeRequired;
  final String paymentTerms;
  final int minimumRequiredScore;
  final String minimumClassification;
  final String minimumClassificationText;
  final String bidDeadlineText;
  final String description;
  final bool alreadyBid;

  const Project({
    required this.projectId,
    required this.title,
    required this.postedByCompanyName,
    required this.sector,
    required this.location,
    required this.contractValueJod,
    required this.timelineText,
    required this.milestones,
    required this.guaranteeTypeRequired,
    required this.paymentTerms,
    required this.minimumRequiredScore,
    required this.minimumClassification,
    required this.minimumClassificationText,
    required this.bidDeadlineText,
    required this.description,
    required this.alreadyBid,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      postedByCompanyName: json['postedByCompanyName'] as String,
      sector: json['sector'] as String,
      location: json['location'] as String,
      contractValueJod: (json['contractValueJod'] as num).toDouble(),
      timelineText: json['timelineText'] as String,
      milestones: json['milestones'] as String,
      guaranteeTypeRequired: json['guaranteeTypeRequired'] as String,
      paymentTerms: json['paymentTerms'] as String,
      minimumRequiredScore: json['minimumRequiredScore'] as int,
      minimumClassification: json['minimumClassification'] as String,
      minimumClassificationText: json['minimumClassificationText'] as String,
      bidDeadlineText: json['bidDeadlineText'] as String,
      description: json['description'] as String,
      alreadyBid: json['alreadyBid'] as bool,
    );
  }
}

class SubmitBidResponse {
  final String bidId;
  final String projectId;
  final String status;

  const SubmitBidResponse({
    required this.bidId,
    required this.projectId,
    required this.status,
  });

  factory SubmitBidResponse.fromJson(Map<String, dynamic> json) {
    return SubmitBidResponse(
      bidId: json['bidId'] as String,
      projectId: json['projectId'] as String,
      status: json['status'] as String,
    );
  }
}
