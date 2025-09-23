import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications({
    NotificationType? type,
    NotificationStatus? status,
  });
  
  Future<NotificationEntity> getNotificationById(String id);
  
  Future<void> markAsRead(String id);
  
  Future<void> markAllAsRead();
  
  Future<void> archiveNotification(String id);
  
  Future<void> deleteNotification(String id);
  
  Future<int> getUnreadCount();
  
  Stream<List<NotificationEntity>> getNotificationsStream();
}
