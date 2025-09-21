import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class LocationStepWidget extends StatelessWidget {
  final String location;
  final Function(String) onLocationChanged;

  const LocationStepWidget({
    super.key,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Service Location',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please provide the location where the service should be performed.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 32),
        
        // Location Input
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9ECEF)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            initialValue: location,
            onChanged: onLocationChanged,
            decoration: const InputDecoration(
              labelText: 'Location',
              hintText: 'Enter your address or area',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
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
        
      ],
    );
  }
}
