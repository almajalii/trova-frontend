class ProjectModel {
  final String id;
  final String title;
  final String companyName;
  final String category;
  final double budget;
  final String budgetDisplay;
  final int minScore;
  final int daysLeft;

  ProjectModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.category,
    required this.budget,
    required this.budgetDisplay,
    required this.minScore,
    required this.daysLeft,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      companyName: json['companyName'] as String,
      category: json['category'] as String,
      budget: (json['budget'] as num).toDouble(),
      budgetDisplay: json['budgetDisplay'] as String,
      minScore: json['minScore'] as int,
      daysLeft: json['daysLeft'] as int,
    );
  }
}