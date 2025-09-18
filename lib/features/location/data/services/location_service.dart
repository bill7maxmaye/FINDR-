import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/location_entity.dart';

class LocationService {
  static const String _locationsKey = 'saved_locations';
  static LocationService? _instance;
  
  LocationService._internal();
  
  static LocationService get instance {
    _instance ??= LocationService._internal();
    return _instance!;
  }

  Future<List<LocationEntity>> getAllLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getStringList(_locationsKey) ?? [];
      
      return locationsJson
          .map((jsonString) => LocationEntity.fromJson(jsonDecode(jsonString)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<LocationEntity> addLocation({
    required String subCity,
    required String worada,
    required String name,
    required double longitude,
    required double latitude,
    bool isPrimary = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingLocations = await getAllLocations();
      
      // If this is set as primary, remove primary from all other locations
      if (isPrimary) {
        for (int i = 0; i < existingLocations.length; i++) {
          existingLocations[i] = existingLocations[i].copyWith(isPrimary: false);
        }
      }
      
      final newLocation = LocationEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        subCity: subCity,
        worada: worada,
        name: name,
        longitude: longitude,
        latitude: latitude,
        isPrimary: isPrimary,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      existingLocations.add(newLocation);
      
      final locationsJson = existingLocations
          .map((location) => jsonEncode(location.toJson()))
          .toList();
      
      await prefs.setStringList(_locationsKey, locationsJson);
      return newLocation;
    } catch (e) {
      throw Exception('Failed to add location: $e');
    }
  }

  Future<LocationEntity> updateLocation({
    required String id,
    String? subCity,
    String? worada,
    String? name,
    double? longitude,
    double? latitude,
    bool? isPrimary,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingLocations = await getAllLocations();
      
      final locationIndex = existingLocations.indexWhere((loc) => loc.id == id);
      if (locationIndex == -1) {
        throw Exception('Location not found');
      }
      
      final existingLocation = existingLocations[locationIndex];
      
      // If this is set as primary, remove primary from all other locations
      if (isPrimary == true) {
        for (int i = 0; i < existingLocations.length; i++) {
          if (i != locationIndex) {
            existingLocations[i] = existingLocations[i].copyWith(isPrimary: false);
          }
        }
      }
      
      final updatedLocation = existingLocation.copyWith(
        subCity: subCity,
        worada: worada,
        name: name,
        longitude: longitude,
        latitude: latitude,
        isPrimary: isPrimary,
        updatedAt: DateTime.now(),
      );
      
      existingLocations[locationIndex] = updatedLocation;
      
      final locationsJson = existingLocations
          .map((location) => jsonEncode(location.toJson()))
          .toList();
      
      await prefs.setStringList(_locationsKey, locationsJson);
      return updatedLocation;
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  Future<void> deleteLocation(String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingLocations = await getAllLocations();
      
      existingLocations.removeWhere((loc) => loc.id == locationId);
      
      final locationsJson = existingLocations
          .map((location) => jsonEncode(location.toJson()))
          .toList();
      
      await prefs.setStringList(_locationsKey, locationsJson);
    } catch (e) {
      throw Exception('Failed to delete location: $e');
    }
  }

  Future<LocationEntity?> getLocationById(String locationId) async {
    try {
      final locations = await getAllLocations();
      return locations.firstWhere(
        (loc) => loc.id == locationId,
        orElse: () => throw Exception('Location not found'),
      );
    } catch (e) {
      return null;
    }
  }

  Future<LocationEntity> setPrimaryLocation(String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingLocations = await getAllLocations();
      
      // Remove primary from all locations
      for (int i = 0; i < existingLocations.length; i++) {
        existingLocations[i] = existingLocations[i].copyWith(isPrimary: false);
      }
      
      // Set the specified location as primary
      final locationIndex = existingLocations.indexWhere((loc) => loc.id == locationId);
      if (locationIndex == -1) {
        throw Exception('Location not found');
      }
      
      existingLocations[locationIndex] = existingLocations[locationIndex].copyWith(
        isPrimary: true,
        updatedAt: DateTime.now(),
      );
      
      final locationsJson = existingLocations
          .map((location) => jsonEncode(location.toJson()))
          .toList();
      
      await prefs.setStringList(_locationsKey, locationsJson);
      return existingLocations[locationIndex];
    } catch (e) {
      throw Exception('Failed to set primary location: $e');
    }
  }
}
