import 'notification_api.dart';
import '../models/notification_model.dart';
import '../../domain/entities/notification.dart';

class NotificationApiImpl implements NotificationApi {
  // Mock data for testing
  final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: '1',
      title: 'Request accepted',
      message: 'Your request was accepted',
      type: NotificationType.request,
      status: NotificationStatus.unread,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      actionText: 'Open chat',
      actionRoute: '/chat',
    ),
    NotificationModel(
      id: '2',
      title: 'Booking rejected',
      message: 'Your booking was rejected',
      type: NotificationType.booking,
      status: NotificationStatus.unread,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      actionText: 'View booking',
      actionRoute: '/booking',
    ),
    NotificationModel(
      id: '3',
      title: 'Dispute resolved',
      message: 'Your dispute has been resolved',
      additionalInfo: 'Refund issued to your card.',
      type: NotificationType.dispute,
      status: NotificationStatus.read,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      actionText: 'View details',
      actionRoute: '/dispute',
    ),
    NotificationModel(
      id: '4',
      title: 'Payment received',
      message: 'Payment of \$150 has been received',
      type: NotificationType.payment,
      status: NotificationStatus.unread,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      actionText: 'View transaction',
      actionRoute: '/payment',
    ),
    NotificationModel(
      id: '5',
      title: 'System maintenance',
      message: 'Scheduled maintenance will occur tonight',
      type: NotificationType.system,
      status: NotificationStatus.read,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<NotificationModel>> getNotifications({
    String? type,
    String? status,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    var filteredNotifications = _mockNotifications;
    
    if (type != null) {
      final notificationType = NotificationType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => NotificationType.system,
      );
      filteredNotifications = filteredNotifications
          .where((n) => n.type == notificationType)
          .toList();
    }
    
    if (status != null) {
      final notificationStatus = NotificationStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => NotificationStatus.unread,
      );
      filteredNotifications = filteredNotifications
          .where((n) => n.status == notificationStatus)
          .toList();
    }
    
    // Sort by timestamp (newest first)
    filteredNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return filteredNotifications;
  }

  @override
  Future<NotificationModel> getNotificationById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final notification = _mockNotifications.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception('Notification not found'),
    );
    
    return notification;
  }

  @override
  Future<void> markAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final index = _mockNotifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _mockNotifications[index] = NotificationModel.fromEntity(
        _mockNotifications[index].copyWith(
          status: NotificationStatus.read,
        ),
      );
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    for (int i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = NotificationModel.fromEntity(
        _mockNotifications[i].copyWith(
          status: NotificationStatus.read,
        ),
      );
    }
  }

  @override
  Future<void> archiveNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    _mockNotifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    _mockNotifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    return _mockNotifications
        .where((n) => n.status == NotificationStatus.unread)
        .length;
  }
}
