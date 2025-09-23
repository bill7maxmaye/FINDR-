import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

class GetNotifications {
  final NotificationRepository _repository;

  const GetNotifications(this._repository);

  Future<List<NotificationEntity>> call({
    NotificationType? type,
    NotificationStatus? status,
  }) async {
    return await _repository.getNotifications(
      type: type,
      status: status,
    );
  }
}
