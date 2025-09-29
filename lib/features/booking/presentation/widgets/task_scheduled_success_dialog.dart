import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class TaskScheduledSuccessDialog extends StatelessWidget {
  final String taskTitle;
  final String scheduledDate;
  final String scheduledTime;
  final String providerName;
  final VoidCallback? onViewRequest;
  final VoidCallback? onClose;

  const TaskScheduledSuccessDialog({
    Key? key,
    required this.taskTitle,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.providerName,
    this.onViewRequest,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    onClose?.call();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),

            // Success Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: AppTheme.primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 24),

            // Success Title
            const Text(
              'Task Scheduled Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Confirmation Message
            Text(
              'Your task has been scheduled for $scheduledDate at $scheduledTime',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Details Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  Text(
                    taskTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    'You\'ll receive a confirmation email shortly with all the details. $providerName will reach out to you before the scheduled time to confirm any specific requirements.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Close Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      onClose?.call();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // View My Request Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onViewRequest?.call();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View My Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show({
    required BuildContext context,
    required String taskTitle,
    required String scheduledDate,
    required String scheduledTime,
    required String providerName,
    VoidCallback? onViewRequest,
    VoidCallback? onClose,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TaskScheduledSuccessDialog(
        taskTitle: taskTitle,
        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        providerName: providerName,
        onViewRequest: onViewRequest,
        onClose: onClose,
      ),
    );
  }
}
