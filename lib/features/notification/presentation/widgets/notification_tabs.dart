import 'package:flutter/material.dart';
import '../../domain/entities/notification.dart';

class NotificationTabs extends StatelessWidget {
  final NotificationType? selectedType;
  final Function(NotificationType?) onTypeSelected;

  const NotificationTabs({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildTab('All', null),
              const SizedBox(width: 12),
              _buildTab('Requests', NotificationType.request),
              const SizedBox(width: 12),
              _buildTab('Bookings', NotificationType.booking),
              const SizedBox(width: 12),
              _buildTab('Disputes', NotificationType.dispute),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, NotificationType? type) {
    final isSelected = selectedType == type;
    
    return GestureDetector(
      onTap: () => onTypeSelected(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
