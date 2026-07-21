import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/core/app_text.dart';
import 'package:trova/core/button.dart';
import 'package:trova/core/di/service_locator.dart';
import 'package:trova/features/notifications/logic/notification_service.dart';
import 'package:trova/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:trova/features/notifications/presentation/bloc/notification_event.dart';
import 'package:trova/features/notifications/presentation/bloc/notification_state.dart';
import 'package:trova/features/notifications/presentation/widget/notifications_layout.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => NotificationBloc(notificationService: sl<NotificationService>())
          ..add(const NotificationsRequested()),
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationInitial || state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotificationError) {
              return _ErrorView(
                message: state.message,
                onRetry: () => context.read<NotificationBloc>().add(const NotificationsRequested()),
              );
            }
            final notifications = (state as NotificationLoaded).notifications;
            return NotificationsLayout(
              notifications: notifications,
              onBack: () => Navigator.of(context).maybePop(),
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(text: message, textSize: 14, textColor: colors.onSurface, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Button(
                text: 'Retry',
                textColor: Colors.white,
                borderRadius: 10,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                elevation: 0,
                buttonWidth: 160,
                buttonHeight: 44,
                onPressed: onRetry,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
