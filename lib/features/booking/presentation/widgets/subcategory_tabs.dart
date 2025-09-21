import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class SubcategoryTabs extends StatelessWidget {
  final List<String> subcategories;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const SubcategoryTabs({
    super.key,
    required this.subcategories,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIconForSubcategory(subcategories[index]),
                      size: 16,
                      color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subcategories[index],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected ? Colors.white : AppTheme.textSecondaryColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForSubcategory(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'ac repair':
        return Icons.build;
      case 'installation':
        return Icons.install_desktop;
      case 'hanging':
        return Icons.handyman;
      case 'servicing':
        return Icons.settings;
      case 'paint':
        return Icons.brush;
      default:
        return Icons.category;
    }
  }
}
