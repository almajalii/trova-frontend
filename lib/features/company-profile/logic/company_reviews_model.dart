// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/company-profile/reviews  (Bearer auth)
// {
//   "averageRating": 4.8,
//   "totalReviews": 11,
//   "items": [
//     { "reviewerName": "Al-Noor Development", "projectTitle": "Al-Noor Tower Construction",
//       "stars": 5, "comment": "Delivered on time and within budget. Great communication throughout." }
//   ]
// }
// Reviews are left via the existing leave-review flow (see
// features/leave-review) — this is just the read side, shown on the
// contractor's own Company Profile screen.
// ───────────────────────────────────────────────────────────────────────

class CompanyReviewItem {
  final String reviewerName;
  final String projectTitle;
  final int stars; // 1-5
  final String comment;

  const CompanyReviewItem({
    required this.reviewerName,
    required this.projectTitle,
    required this.stars,
    required this.comment,
  });

  factory CompanyReviewItem.fromJson(Map<String, dynamic> json) => CompanyReviewItem(
        reviewerName: json['reviewerName'] as String,
        projectTitle: json['projectTitle'] as String,
        stars: json['stars'] as int,
        comment: json['comment'] as String,
      );
}

class CompanyReviewsSummary {
  final double averageRating;
  final int totalReviews;
  final List<CompanyReviewItem> items;

  const CompanyReviewsSummary({required this.averageRating, required this.totalReviews, required this.items});

  factory CompanyReviewsSummary.fromJson(Map<String, dynamic> json) => CompanyReviewsSummary(
        averageRating: (json['averageRating'] as num).toDouble(),
        totalReviews: json['totalReviews'] as int,
        items: (json['items'] as List).map((e) => CompanyReviewItem.fromJson(e as Map<String, dynamic>)).toList(),
      );

  /// Demo data matching the Figma mock.
  static CompanyReviewsSummary demo() => const CompanyReviewsSummary(
        averageRating: 4.8,
        totalReviews: 11,
        items: [
          CompanyReviewItem(
            reviewerName: 'Al-Noor Development',
            projectTitle: 'Al-Noor Tower Construction',
            stars: 5,
            comment: 'Delivered on time and within budget. Great communication throughout.',
          ),
          CompanyReviewItem(
            reviewerName: 'Riverside Holdings',
            projectTitle: 'Riverside Complex',
            stars: 5,
            comment: 'Excellent quality of work. Would definitely hire again.',
          ),
          CompanyReviewItem(
            reviewerName: 'Zaytoonah Group',
            projectTitle: 'Business Park Renovation',
            stars: 4,
            comment: 'Solid work, minor delays but resolved quickly.',
          ),
        ],
      );
}
