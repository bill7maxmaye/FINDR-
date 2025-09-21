import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class DetailsStepWidget extends StatelessWidget {
  final String title;
  final String summary;
  final List<String> images;
  final Function(String) onTitleChanged;
  final Function(String) onSummaryChanged;
  final Function(String) onImageAdded;
  final Function(int) onImageRemoved;

  const DetailsStepWidget({
    super.key,
    required this.title,
    required this.summary,
    required this.images,
    required this.onTitleChanged,
    required this.onSummaryChanged,
    required this.onImageAdded,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Task Details',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please state what you need done. We will send this to providers.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 32),
        
        // Task Title Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: title,
              onChanged: onTitleChanged,
              decoration: const InputDecoration(
                hintText: 'Provide a brief, clear summary of what you need done.',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 1,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Task Summary Field
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: summary,
              onChanged: onSummaryChanged,
              decoration: const InputDecoration(
                hintText: 'Include specific details that need special attention. The more details you provide, the better quotes you\'ll receive.',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16),
              ),
              maxLines: 5,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Add Images Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add images (optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            
            // Image Upload Area
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE9ECEF),
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF8F9FA),
              ),
              child: images.isEmpty
                  ? _buildImageUploadPlaceholder()
                  : _buildImageGrid(),
            ),
          ],
        ),
        
      ],
    );
  }

  Widget _buildImageUploadPlaceholder() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picker
        onImageAdded('placeholder_image_path');
      },
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 8),
            Text(
              'Click to add images',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length + 1, // +1 for add button
      itemBuilder: (context, index) {
        if (index == images.length) {
          // Add button
          return GestureDetector(
            onTap: () {
              // TODO: Implement image picker
              onImageAdded('placeholder_image_path');
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE9ECEF),
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.add,
                color: AppTheme.primaryColor,
              ),
            ),
          );
        } else {
          // Image thumbnail
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/placeholder.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onImageRemoved(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
