import '../models/notification_model.dart';

abstract class NotificationApi {
  Future<List<NotificationModel>> getNotifications({
    String? type,
    String? status,
  });
  
  Future<NotificationModel> getNotificationById(String id);
  
  Future<void> markAsRead(String id);
  
  Future<void> markAllAsRead();
  
  Future<void> archiveNotification(String id);
  
  Future<void> deleteNotification(String id);
  
  Future<int> getUnreadCount();
}
