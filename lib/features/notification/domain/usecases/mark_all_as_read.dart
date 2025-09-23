import '../repositories/notification_repository.dart';

class MarkAllAsRead {
  final NotificationRepository _repository;

  const MarkAllAsRead(this._repository);

  Future<void> call() async {
    await _repository.markAllAsRead();
  }
}
