import '../../domain/entities/notification.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final NotificationType? type;
  final NotificationStatus? status;

  LoadNotifications({this.type, this.status});
}

class RefreshNotifications extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  MarkAsRead(this.notificationId);
}

class MarkAllAsRead extends NotificationEvent {}

class ArchiveNotification extends NotificationEvent {
  final String notificationId;

  ArchiveNotification(this.notificationId);
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  DeleteNotification(this.notificationId);
}

class FilterByType extends NotificationEvent {
  final NotificationType? type;

  FilterByType(this.type);
}

class FilterByStatus extends NotificationEvent {
  final NotificationStatus? status;

  FilterByStatus(this.status);
}
