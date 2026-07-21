class Project {
  final String id;
  final String title;
  final String postedBy;
  final String sector;
  final String location;
  final double contractValue;
  final String timeline;
  final String milestones;
  final String guaranteeTypeRequired;
  final String paymentTerms;
  final int minimumScore;
  final String minimumClassification;
  final DateTime bidDeadline;
  final String description;

  const Project({
    required this.id,
    required this.title,
    required this.postedBy,
    required this.sector,
    required this.location,
    required this.contractValue,
    required this.timeline,
    required this.milestones,
    required this.guaranteeTypeRequired,
    required this.paymentTerms,
    required this.minimumScore,
    required this.minimumClassification,
    required this.bidDeadline,
    required this.description,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      postedBy: json['postedBy'] as String,
      sector: json['sector'] as String,
      location: json['location'] as String,
      contractValue: (json['contractValue'] as num).toDouble(),
      timeline: json['timeline'] as String,
      milestones: json['milestones'] as String,
      guaranteeTypeRequired: json['guaranteeTypeRequired'] as String,
      paymentTerms: json['paymentTerms'] as String,
      minimumScore: json['minimumScore'] as int,
      minimumClassification: json['minimumClassification'] as String,
      bidDeadline: DateTime.parse(json['bidDeadline'] as String),
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'postedBy': postedBy,
      'sector': sector,
      'location': location,
      'contractValue': contractValue,
      'timeline': timeline,
      'milestones': milestones,
      'guaranteeTypeRequired': guaranteeTypeRequired,
      'paymentTerms': paymentTerms,
      'minimumScore': minimumScore,
      'minimumClassification': minimumClassification,
      'bidDeadline': bidDeadline.toIso8601String(),
      'description': description,
    };
  }
}