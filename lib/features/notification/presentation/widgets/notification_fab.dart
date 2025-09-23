import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';

class NotificationFAB extends StatelessWidget {
  final int? unreadCount;

  const NotificationFAB({
    super.key,
    this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.go('/notifications');
      },
      backgroundColor: AppTheme.primaryColor,
      child: Stack(
        children: [
          const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          if (unreadCount != null && unreadCount! > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
