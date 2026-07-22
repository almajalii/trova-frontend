class ProjectModel {
  final String projectId;
  final String title;
  final String postedByCompanyName;
  final String sector;
  final double contractValueJod;
  final int minimumRequiredScore;
  final String minimumClassification;
  final String daysLeftText;

  ProjectModel({
    required this.projectId,
    required this.title,
    required this.postedByCompanyName,
    required this.sector,
    required this.contractValueJod,
    required this.minimumRequiredScore,
    required this.minimumClassification,
    required this.daysLeftText,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      postedByCompanyName: json['postedByCompanyName'] as String,
      sector: json['sector'] as String,
      contractValueJod: (json['contractValueJod'] as num).toDouble(),
      minimumRequiredScore: json['minimumRequiredScore'] as int,
      minimumClassification: json['minimumClassification'] as String,
      daysLeftText: json['daysLeftText'] as String,
    );
  }
}
