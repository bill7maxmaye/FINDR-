import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class TaskPostingProgressSidebar extends StatelessWidget {
  final int currentStep;
  final Function(int) onStepTap;

  const TaskPostingProgressSidebar({
    super.key,
    required this.currentStep,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(
          right: BorderSide(
            color: Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Post a task',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 32),
          _buildStepItem(
            step: 0,
            title: 'Location',
            isActive: currentStep == 0,
            isCompleted: currentStep > 0,
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            step: 1,
            title: 'Details',
            isActive: currentStep == 1,
            isCompleted: currentStep > 1,
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            step: 2,
            title: 'Budget and Date',
            isActive: currentStep == 2,
            isCompleted: currentStep > 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required int step,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return GestureDetector(
      onTap: () => onStepTap(step),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: isActive || isCompleted
                  ? AppTheme.primaryColor
                  : const Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive || isCompleted
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
              ),
            ),
          ),
          if (isCompleted)
            const Icon(
              Icons.check_circle,
              size: 16,
              color: AppTheme.successColor,
            ),
        ],
      ),
    );
  }
}
