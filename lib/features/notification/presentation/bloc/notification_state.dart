import '../../domain/entities/notification.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final NotificationType? selectedType;
  final NotificationStatus? selectedStatus;
  final int unreadCount;

  NotificationLoaded({
    required this.notifications,
    this.selectedType,
    this.selectedStatus,
    required this.unreadCount,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    NotificationType? selectedType,
    NotificationStatus? selectedStatus,
    int? unreadCount,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      selectedType: selectedType ?? this.selectedType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}

class NotificationActionSuccess extends NotificationState {
  final String message;

  NotificationActionSuccess(this.message);
}
