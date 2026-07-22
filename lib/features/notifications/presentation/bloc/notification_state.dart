import 'package:equatable/equatable.dart';
import 'package:trova/features/notifications/logic/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationItem> notifications;
  const NotificationLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
