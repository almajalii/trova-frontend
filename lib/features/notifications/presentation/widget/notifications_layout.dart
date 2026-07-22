import 'package:flutter/material.dart';
import 'package:trova/core/app_colors.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/app_title.dart';
import 'package:trova/core/responsive_utils.dart';
import 'package:trova/features/notifications/logic/notification_model.dart';

class NotificationsLayout extends StatelessWidget {
  final List<NotificationItem> notifications;
  final VoidCallback onBack;

  const NotificationsLayout({super.key, required this.notifications, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: context.horizontal).copyWith(top: 8, bottom: 24),
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: colors.onSurface),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 8),
          AppTitle(
            title: 'Notifications',
            size: 24,
            weight: FontWeight.w700,
            titleColor: colors.onSurface,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          if (notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: AppText(
                  text: "You're all caught up.",
                  textSize: 14,
                  textColor: colors.onSurfaceVariant,
                ),
              ),
            )
          else
            for (final item in notifications) ...[
              _NotificationCard(item: item),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  const _NotificationCard({required this.item});

  (IconData, Color, Color) _iconFor(NotificationType type, ColorScheme colors) {
    switch (type) {
      case NotificationType.scoreIncreased:
        return (Icons.arrow_upward, AppColors.successBg, AppColors.success);
      case NotificationType.guaranteeIssued:
        return (Icons.check, AppColors.primaryTint, colors.primary);
      case NotificationType.guaranteeExpiring:
        return (Icons.priority_high, AppColors.primaryTint, colors.primary);
      case NotificationType.reviewReceived:
        return (Icons.star, AppColors.primaryTint, colors.primary);
      case NotificationType.bidUnderReview:
        return (Icons.circle, AppColors.neutralTagBg, colors.onSurfaceVariant);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (icon, bg, fg) = _iconFor(item.type, colors);
    final isDot = item.type == NotificationType.bidUnderReview;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border.all(color: colors.surfaceBright), borderRadius: BorderRadius.circular(14)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: fg, size: isDot ? 10 : 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: item.message,
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: colors.onSurface,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 4),
                AppText(text: item.timeAgo, textSize: 12, textColor: colors.onSurfaceVariant, textAlign: TextAlign.start),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
