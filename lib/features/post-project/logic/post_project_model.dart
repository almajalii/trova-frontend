// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// POST /api/projects
// {
//   "title": "Al-Noor Tower Construction",
//   "contractValueJod": 240000,
//   "minimumRequiredScore": 80,
//   "minimumClassification": "B",      // enum: A | B | C
//   "description": "..."
// }
// → 201 { "data": { "projectId": "..." } }
// ───────────────────────────────────────────────────────────────────────

enum ClassificationCode { a, b, c }

extension ClassificationCodeX on ClassificationCode {
  String get apiValue {
    switch (this) {
      case ClassificationCode.a:
        return 'A';
      case ClassificationCode.b:
        return 'B';
      case ClassificationCode.c:
        return 'C';
    }
  }

  String get dropdownLabel {
    switch (this) {
      case ClassificationCode.a:
        return 'Class A or higher (Large+)';
      case ClassificationCode.b:
        return 'Class B or higher (Medium+)';
      case ClassificationCode.c:
        return 'Class C or higher (Any)';
    }
  }
}

class ProjectDraft {
  final String title;
  final double contractValueJod;
  final int minimumRequiredScore;
  final ClassificationCode minimumClassification;
  final String description;

  const ProjectDraft({
    required this.title,
    required this.contractValueJod,
    required this.minimumRequiredScore,
    required this.minimumClassification,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'contractValueJod': contractValueJod,
        'minimumRequiredScore': minimumRequiredScore,
        'minimumClassification': minimumClassification.apiValue,
        'description': description,
      };
}
