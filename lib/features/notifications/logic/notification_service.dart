import 'package:dio/dio.dart';
import 'package:trova/core/mock_mode.dart';
import 'package:trova/core/network/api_exception.dart';
import 'package:trova/features/notifications/logic/notification_model.dart';

class NotificationService {
  final Dio dio;
  NotificationService({required this.dio});

  Future<List<NotificationItem>> fetchNotifications() async {
    if (kUseMockNotifications) {
      await Future.delayed(const Duration(milliseconds: 300));
      return NotificationItem.demo();
    }
    try {
      final response = await dio.get('/notifications');
      return (response.data['data'] as List)
          .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
