import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_api.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi _api;

  const NotificationRepositoryImpl(this._api);

  @override
  Future<List<NotificationEntity>> getNotifications({
    NotificationType? type,
    NotificationStatus? status,
  }) async {
    final models = await _api.getNotifications(
      type: type?.name,
      status: status?.name,
    );
    return models.map((model) => model as NotificationEntity).toList();
  }

  @override
  Future<NotificationEntity> getNotificationById(String id) async {
    final model = await _api.getNotificationById(id);
    return model as NotificationEntity;
  }

  @override
  Future<void> markAsRead(String id) async {
    await _api.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() async {
    await _api.markAllAsRead();
  }

  @override
  Future<void> archiveNotification(String id) async {
    await _api.archiveNotification(id);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _api.deleteNotification(id);
  }

  @override
  Future<int> getUnreadCount() async {
    return await _api.getUnreadCount();
  }

  @override
  Stream<List<NotificationEntity>> getNotificationsStream() {
    // This would typically be implemented with a real-time stream
    // For now, we'll return a periodic stream that fetches notifications
    return Stream.periodic(const Duration(seconds: 30), (_) async {
      return await getNotifications();
    }).asyncMap((future) => future);
  }
}
