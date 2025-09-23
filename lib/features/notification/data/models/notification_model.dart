import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    super.additionalInfo,
    required super.type,
    required super.status,
    required super.timestamp,
    super.actionText,
    super.actionRoute,
    super.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      additionalInfo: json['additionalInfo'] as String?,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      status: NotificationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => NotificationStatus.unread,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      actionText: json['actionText'] as String?,
      actionRoute: json['actionRoute'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'additionalInfo': additionalInfo,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'actionText': actionText,
      'actionRoute': actionRoute,
      'metadata': metadata,
    };
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      additionalInfo: entity.additionalInfo,
      type: entity.type,
      status: entity.status,
      timestamp: entity.timestamp,
      actionText: entity.actionText,
      actionRoute: entity.actionRoute,
      metadata: entity.metadata,
    );
  }
}
