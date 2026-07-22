// ── DATA SHAPE NOTE FOR BACKEND ──────────────────────────────────────────
// GET /api/notifications  (Bearer auth)
// [
//   { "type": "SCORE_INCREASED", "message": "Your Capability Score increased by 3 points",
//     "timestamp": "2026-07-21T14:00:00Z" }
// ]
// "timestamp" is an ISO-8601 instant — the "2 hours ago" / "3 days ago"
// display text is derived client-side (see NotificationItem.timeAgo) so it
// stays accurate instead of going stale like a pre-formatted string would.
// ───────────────────────────────────────────────────────────────────────

enum NotificationType {
  scoreIncreased,
  guaranteeIssued,
  guaranteeExpiring,
  reviewReceived,
  bidUnderReview;

  static NotificationType fromJson(String value) => switch (value) {
        'SCORE_INCREASED' => NotificationType.scoreIncreased,
        'GUARANTEE_ISSUED' => NotificationType.guaranteeIssued,
        'GUARANTEE_EXPIRING' => NotificationType.guaranteeExpiring,
        'REVIEW_RECEIVED' => NotificationType.reviewReceived,
        'BID_UNDER_REVIEW' => NotificationType.bidUnderReview,
        _ => NotificationType.bidUnderReview,
      };
}

class NotificationItem {
  final NotificationType type;
  final String message;
  final DateTime timestamp;

  const NotificationItem({required this.type, required this.message, required this.timestamp});

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
        type: NotificationType.fromJson(json['type'] as String),
        message: json['message'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String).toLocal(),
      );

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    if (diff.inHours < 24) return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  }

  /// Demo data matching the Figma mock.
  static List<NotificationItem> demo() {
    final now = DateTime.now();
    return [
      NotificationItem(
        type: NotificationType.scoreIncreased,
        message: 'Your Capability Score increased by 3 points',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        type: NotificationType.guaranteeIssued,
        message: 'Your bank guarantee for Riverside Complex was issued',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        type: NotificationType.guaranteeExpiring,
        message: 'Your guarantee for Al-Salam Mall expires in 7 days',
        timestamp: now.subtract(const Duration(days: 2)),
      ),
      NotificationItem(
        type: NotificationType.reviewReceived,
        message: 'Al-Noor Development left you a 5-star review',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      NotificationItem(
        type: NotificationType.bidUnderReview,
        message: 'Your bid on Al-Noor Tower is under review',
        timestamp: now.subtract(const Duration(days: 4)),
      ),
    ];
  }
}
