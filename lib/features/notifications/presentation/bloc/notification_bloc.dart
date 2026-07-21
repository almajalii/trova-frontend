import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trova/features/notifications/logic/notification_service.dart';
import 'package:trova/features/notifications/presentation/bloc/notification_event.dart';
import 'package:trova/features/notifications/presentation/bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc({required this.notificationService}) : super(const NotificationInitial()) {
    on<NotificationsRequested>((event, emit) async {
      emit(const NotificationLoading());
      try {
        final notifications = await notificationService.fetchNotifications();
        emit(NotificationLoaded(notifications: notifications));
      } catch (e) {
        emit(NotificationError(message: e.toString()));
      }
    });
  }
}
