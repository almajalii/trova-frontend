// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/home/summary  (Bearer auth)
// {
//   "userName": "Ahmad Khalil",
//   "greeting": "Good morning",             // or derive client-side from local time
//   "score": { "overall": 94, "tierLabel": "Strong Capability", "monthlyChangePoints": 3 },
//   "classification": { "code": "A", "label": "Large Enterprise" },
//   "eligibleProjects": [
//     { "title": "Al-Noor Tower Construction", "sector": "Construction",
//       "contractValueJod": 240000, "daysLeft": 5 }
//   ],
//   "recentActivity": [
//     { "type": "BID_SUBMITTED", "title": "Bid Submitted",
//       "subtitle": "Al-Noor Tower Project · JOD 240,000", "status": "PENDING" },
//     { "type": "GUARANTEE_ISSUED", "title": "Guarantee Issued",
//       "subtitle": "Riverside Complex · Expires in 90 days", "status": "ACTIVE" }
//   ]
// }
// ───────────────────────────────────────────────────────────────────────

class HomeScoreSummary {
  final int overall;
  final String tierLabel;
  final int monthlyChangePoints;
  const HomeScoreSummary({required this.overall, required this.tierLabel, required this.monthlyChangePoints});

  factory HomeScoreSummary.fromJson(Map<String, dynamic> json) => HomeScoreSummary(
        overall: json['overall'] as int,
        tierLabel: json['tierLabel'] as String,
        monthlyChangePoints: json['monthlyChangePoints'] as int,
      );
}

class ClassificationSummary {
  final String code; // A | B | C
  final String label;
  const ClassificationSummary({required this.code, required this.label});

  // Backend sometimes sends label already formatted as "Class A" instead of
  // just "Large Enterprise" — prepending "Class $code ·" unconditionally
  // then reads as "Class A · Class A". Only prepend it when label doesn't
  // already include the code.
  String get display {
    final trimmedLabel = label.trim();
    if (trimmedLabel.toLowerCase().contains('class $code'.toLowerCase())) {
      return trimmedLabel;
    }
    return 'Class $code · $trimmedLabel';
  }

  factory ClassificationSummary.fromJson(Map<String, dynamic> json) =>
      ClassificationSummary(code: json['code'] as String, label: json['label'] as String);
}

class EligibleProjectSummary {
  final String title;
  final String sector;
  final double contractValueJod;
  final int daysLeft;
  const EligibleProjectSummary({
    required this.title,
    required this.sector,
    required this.contractValueJod,
    required this.daysLeft,
  });

  factory EligibleProjectSummary.fromJson(Map<String, dynamic> json) => EligibleProjectSummary(
        title: json['title'] as String,
        sector: json['sector'] as String,
        contractValueJod: (json['contractValueJod'] as num).toDouble(),
        daysLeft: json['daysLeft'] as int,
      );
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String status; // PENDING | ACTIVE | ...
  const ActivityItem({required this.title, required this.subtitle, required this.status});

  factory ActivityItem.fromJson(Map<String, dynamic> json) =>
      ActivityItem(title: json['title'] as String, subtitle: json['subtitle'] as String, status: json['status'] as String);
}

class HomeSummary {
  final String userName;
  final String greeting;
  final HomeScoreSummary score;
  final ClassificationSummary classification;
  final List<EligibleProjectSummary> eligibleProjects;
  final List<ActivityItem> recentActivity;

  const HomeSummary({
    required this.userName,
    required this.greeting,
    required this.score,
    required this.classification,
    required this.eligibleProjects,
    required this.recentActivity,
  });

  factory HomeSummary.fromJson(Map<String, dynamic> json) => HomeSummary(
        userName: json['userName'] as String,
        greeting: json['greeting'] as String,
        score: HomeScoreSummary.fromJson(json['score'] as Map<String, dynamic>),
        classification: ClassificationSummary.fromJson(json['classification'] as Map<String, dynamic>),
        eligibleProjects: (json['eligibleProjects'] as List)
            .map((e) => EligibleProjectSummary.fromJson(e as Map<String, dynamic>))
            .toList(),
        recentActivity:
            (json['recentActivity'] as List).map((e) => ActivityItem.fromJson(e as Map<String, dynamic>)).toList(),
      );

  /// Demo data matching the Figma mock — used by the dev screens gallery.
  static HomeSummary demo() => const HomeSummary(
        userName: 'Ahmad Khalil',
        greeting: 'Good morning',
        score: HomeScoreSummary(overall: 94, tierLabel: 'Strong Capability', monthlyChangePoints: 3),
        classification: ClassificationSummary(code: 'A', label: 'Large Enterprise'),
        eligibleProjects: [
          EligibleProjectSummary(title: 'Al-Noor Tower Construction', sector: 'Construction', contractValueJod: 240000, daysLeft: 5),
        ],
        recentActivity: [
          ActivityItem(title: 'Bid Submitted', subtitle: 'Al-Noor Tower Project · JOD 240,000', status: 'PENDING'),
          ActivityItem(title: 'Guarantee Issued', subtitle: 'Riverside Complex · Expires in 90 days', status: 'ACTIVE'),
        ],
      );
}
