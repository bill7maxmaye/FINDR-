import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../../../../core/theme.dart';
import '../../../booking/presentation/widgets/nested_location_dropdown.dart';

class LocationDetailsStepWidget extends StatefulWidget {
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
  State<LocationDetailsStepWidget> createState() => _LocationDetailsStepWidgetState();
}

class _LocationDetailsStepWidgetState extends State<LocationDetailsStepWidget> {
  Map<String, List<String>> _kifleKetemaData = {};
  String? _selectedKifleKetema;
  String? _selectedWoreda;
  List<String> _availableWoredas = [];

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    try {
      final String response = await rootBundle.loadString('assets/locations.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _kifleKetemaData = Map<String, List<String>>.from(
          data['kifle_ketema'].map((key, value) => MapEntry(key, List<String>.from(value)))
        );
      });
    } catch (e) {
      print('Error loading location data: $e');
    }
  }

  void _updateLocation() {
    if (_selectedKifleKetema != null && _selectedWoreda != null) {
      final location = '$_selectedWoreda, $_selectedKifleKetema';
      widget.onLocationChanged(location);
    }
  }



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
          
          // Nested Location Dropdown
          NestedLocationDropdown(
            selectedKifleKetema: _selectedKifleKetema,
            selectedWoreda: _selectedWoreda,
            onLocationChanged: (kifleKetema, woreda) {
              setState(() {
                _selectedKifleKetema = kifleKetema;
                _selectedWoreda = woreda;
                _availableWoredas = kifleKetema != null ? _kifleKetemaData[kifleKetema] ?? [] : [];
              });
              _updateLocation();
            },
          ),
          
          
          const SizedBox(height: 32),
          
          // Task Title Section
          Text(
            'Task Title',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: widget.title,
            onChanged: widget.onTitleChanged,
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: widget.summary,
            onChanged: widget.onSummaryChanged,
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
            style: AppTextStyles.bodyMedium.copyWith(
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
            itemCount: widget.images.length + 1, // +1 for add button
            itemBuilder: (context, index) {
              if (index == widget.images.length) {
                // Add image button
                return GestureDetector(
                  onTap: () => _showImageSourceDialog(),
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
                          image: FileImage(File(widget.images[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => widget.onImageRemoved(index),
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

  void _showImageSourceDialog() {
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
      widget.onImageAdded(image.path);
    }
  }
}
