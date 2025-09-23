class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String? additionalInfo;
  final NotificationType type;
  final NotificationStatus status;
  final DateTime timestamp;
  final String? actionText;
  final String? actionRoute;
  final Map<String, dynamic>? metadata;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    this.additionalInfo,
    required this.type,
    required this.status,
    required this.timestamp,
    this.actionText,
    this.actionRoute,
    this.metadata,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? additionalInfo,
    NotificationType? type,
    NotificationStatus? status,
    DateTime? timestamp,
    String? actionText,
    String? actionRoute,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      actionText: actionText ?? this.actionText,
      actionRoute: actionRoute ?? this.actionRoute,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum NotificationType {
  request,
  booking,
  dispute,
  system,
  payment,
}

enum NotificationStatus {
  unread,
  read,
  archived,
}
