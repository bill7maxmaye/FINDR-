import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/theme.dart';

class LocationDetailsStepWidget extends StatelessWidget {
  final String location;
  final String title;
  final String summary;
  final List<String> images;
  final Function(String) onLocationChanged;
  final Function(String) onTitleChanged;
  final Function(String) onSummaryChanged;
  final Function(String) onImageAdded;
  final Function(int) onImageRemoved;

  const LocationDetailsStepWidget({
    super.key,
    required this.location,
    required this.title,
    required this.summary,
    required this.images,
    required this.onLocationChanged,
    required this.onTitleChanged,
    required this.onSummaryChanged,
    required this.onImageAdded,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Section
          Text(
            'Service Location',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: location,
            onChanged: onLocationChanged,
            decoration: InputDecoration(
              hintText: 'Enter the service location',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: const Icon(Icons.location_on_outlined),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Use Current Location Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement current location functionality
              },
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: AppTheme.primaryColor),
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Task Title Section
          Text(
            'Task Title',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: title,
            onChanged: onTitleChanged,
            decoration: InputDecoration(
              hintText: 'Enter a clear, descriptive title for your task',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),

          // Task Summary Section
          Text(
            'Task Summary',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: summary,
            onChanged: onSummaryChanged,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Describe your task in detail. What needs to be done?',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),

          // Image Upload Section
          Text(
            'Add Images (Optional)',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload photos to help providers understand your task better',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Image Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: images.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == images.length) {
                // Add image button
                return GestureDetector(
                  onTap: () => _showImageSourceDialog(context),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                );
              } else {
                // Image thumbnail
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(images[index])),
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
                          padding: const EdgeInsets.all(4),
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
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (image != null) {
      onImageAdded(image.path);
    }
  }
}
