import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Notification Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getNotificationColor().withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getNotificationIcon(),
                color: _getNotificationColor(),
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: notification.status == NotificationStatus.unread
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  if (notification.additionalInfo != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      notification.additionalInfo!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Button
            if (notification.actionText != null) ...[
              const SizedBox(width: 12),
              _buildActionButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    final isPrimary = _isPrimaryAction();
    
    return GestureDetector(
      onTap: onActionTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          notification.actionText!,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isPrimary ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.request:
        return Colors.green;
      case NotificationType.booking:
        return Colors.blue;
      case NotificationType.dispute:
        return Colors.orange;
      case NotificationType.payment:
        return Colors.purple;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.request:
        return Icons.handshake;
      case NotificationType.booking:
        return Icons.calendar_today;
      case NotificationType.dispute:
        return Icons.gavel;
      case NotificationType.payment:
        return Icons.payment;
      case NotificationType.system:
        return Icons.info;
    }
  }

  bool _isPrimaryAction() {
    // Determine if this should be a primary (colored) button
    switch (notification.type) {
      case NotificationType.request:
        return notification.actionText?.toLowerCase().contains('chat') == true;
      case NotificationType.booking:
        return notification.actionText?.toLowerCase().contains('view') == true;
      case NotificationType.dispute:
        return false; // Usually secondary actions
      case NotificationType.payment:
        return true;
      case NotificationType.system:
        return false;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}, ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')} ${timestamp.hour >= 12 ? 'PM' : 'AM'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
