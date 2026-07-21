/// The six rating categories shown on the "Leave a Review" screen, in the
/// order they appear in Figma.
enum ReviewCategory {
  qualityOfWorkmanship,
  adherenceToTimeline,
  adherenceToBudgetScope,
  communicationResponsiveness,
  siteSafetyCompliance,
  wouldYouRehire;

  String get label {
    switch (this) {
      case ReviewCategory.qualityOfWorkmanship:
        return 'Quality of Workmanship';
      case ReviewCategory.adherenceToTimeline:
        return 'Adherence to Timeline';
      case ReviewCategory.adherenceToBudgetScope:
        return 'Adherence to Budget/Scope';
      case ReviewCategory.communicationResponsiveness:
        return 'Communication & Responsiveness';
      case ReviewCategory.siteSafetyCompliance:
        return 'Site Safety & Compliance';
      case ReviewCategory.wouldYouRehire:
        return 'Would You Rehire?';
    }
  }

  factory ReviewCategory.fromJson(String raw) {
    switch (raw) {
      case 'quality_of_workmanship':
        return ReviewCategory.qualityOfWorkmanship;
      case 'adherence_to_timeline':
        return ReviewCategory.adherenceToTimeline;
      case 'adherence_to_budget_scope':
        return ReviewCategory.adherenceToBudgetScope;
      case 'communication_responsiveness':
        return ReviewCategory.communicationResponsiveness;
      case 'site_safety_compliance':
        return ReviewCategory.siteSafetyCompliance;
      case 'would_you_rehire':
        return ReviewCategory.wouldYouRehire;
      default:
        throw ArgumentError('Unknown ReviewCategory: $raw');
    }
  }

  String toJson() {
    switch (this) {
      case ReviewCategory.qualityOfWorkmanship:
        return 'quality_of_workmanship';
      case ReviewCategory.adherenceToTimeline:
        return 'adherence_to_timeline';
      case ReviewCategory.adherenceToBudgetScope:
        return 'adherence_to_budget_scope';
      case ReviewCategory.communicationResponsiveness:
        return 'communication_responsiveness';
      case ReviewCategory.siteSafetyCompliance:
        return 'site_safety_compliance';
      case ReviewCategory.wouldYouRehire:
        return 'would_you_rehire';
    }
  }
}

/// Draft review for a completed project. Ratings start unrated (0) — the
/// Figma frame shows most categories pre-filled at 5 stars, but that's
/// sample content, not a real default; a real user should have to tap each
/// row. `0` means "no rating given yet" and is treated as invalid on
/// submit (see [isComplete]).
class LeaveReviewDraft {
  final String projectId;
  final String contractorName;
  final String projectTitle;
  final DateTime completedDate;
  final Map<ReviewCategory, int> ratings;
  final String comment;

  const LeaveReviewDraft({
    required this.projectId,
    required this.contractorName,
    required this.projectTitle,
    required this.completedDate,
    required this.ratings,
    this.comment = '',
  });

  /// True once every category has a 1-5 rating.
  bool get isComplete => ReviewCategory.values.every((c) => (ratings[c] ?? 0) > 0);

  /// Header subtitle, e.g. "Al-Noor Tower Construction · Completed July 2026".
  String get subtitle {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final monthYear = '${months[completedDate.month - 1]} ${completedDate.year}';
    return '$projectTitle · Completed $monthYear';
  }

  LeaveReviewDraft copyWith({Map<ReviewCategory, int>? ratings, String? comment}) {
    return LeaveReviewDraft(
      projectId: projectId,
      contractorName: contractorName,
      projectTitle: projectTitle,
      completedDate: completedDate,
      ratings: ratings ?? this.ratings,
      comment: comment ?? this.comment,
    );
  }

  /// Returns a copy with [category] set to [stars] (1-5).
  LeaveReviewDraft withRating(ReviewCategory category, int stars) {
    final updated = Map<ReviewCategory, int>.from(ratings);
    updated[category] = stars;
    return copyWith(ratings: updated);
  }

  factory LeaveReviewDraft.fromJson(Map<String, dynamic> json) {
    final ratingsJson = json['ratings'] as Map<String, dynamic>;
    return LeaveReviewDraft(
      projectId: json['projectId'] as String,
      contractorName: json['contractorName'] as String,
      projectTitle: json['projectTitle'] as String,
      completedDate: DateTime.parse(json['completedDate'] as String),
      ratings: {for (final entry in ratingsJson.entries) ReviewCategory.fromJson(entry.key): entry.value as int},
      comment: json['comment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'contractorName': contractorName,
      'projectTitle': projectTitle,
      'completedDate': completedDate.toIso8601String(),
      'ratings': {for (final entry in ratings.entries) entry.key.toJson(): entry.value},
      'comment': comment,
    };
  }

  /// Mock data for `kUseMockLeaveReview`. Starts fully unrated + no comment, since
  /// this represents the initial state of the form when an owner opens it
  /// (not a pre-filled example review). The first entry matches the id used
  /// by review-work's `SubmittedWork` demo (Al-Salam Mall) — that's the only
  /// project reachable here via Confirm Complete → Leave a Review.
  static List<LeaveReviewDraft> demoList() {
    return [
      LeaveReviewDraft(
        projectId: 'TRV-PRJ-33871',
        contractorName: 'Al-Fahad Contracting',
        projectTitle: 'Al-Salam Mall',
        completedDate: DateTime(2026, 7, 18),
        ratings: const {},
      ),
      LeaveReviewDraft(
        projectId: 'TRV-PRJ-19042',
        contractorName: 'Cedar Construction',
        projectTitle: 'Downtown Office Renovation',
        completedDate: DateTime(2026, 6, 1),
        ratings: const {},
      ),
    ];
  }
}
