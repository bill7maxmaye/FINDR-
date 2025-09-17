import '../../../../core/network/dio_client.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_api.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationApi _locationApi;

  LocationRepositoryImpl(this._locationApi);

  @override
  Future<List<LocationEntity>> getAllLocations() async {
    try {
      final response = await _locationApi.getAllLocations();
      if (response['success'] == true) {
        final List<dynamic> locationsJson = response['data'];
        return locationsJson
            .map((json) => LocationModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception('Failed to load locations: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to load locations: $e');
    }
  }

  @override
  Future<LocationEntity> addLocation({
    required String subCity,
    required String worada,
    required String name,
    required double longitude,
    required double latitude,
    bool isPrimary = false,
  }) async {
    try {
      final locationData = {
        'subCity': subCity,
        'worada': worada,
        'name': name,
        'longitude': longitude,
        'latitude': latitude,
        'isPrimary': isPrimary,
      };

      final response = await _locationApi.addLocation(locationData);
      if (response['success'] == true) {
        return LocationModel.fromJson(response['data']).toEntity();
      } else {
        throw Exception('Failed to add location: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to add location: $e');
    }
  }

  @override
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
      final locationData = <String, dynamic>{};
      if (subCity != null) locationData['subCity'] = subCity;
      if (worada != null) locationData['worada'] = worada;
      if (name != null) locationData['name'] = name;
      if (longitude != null) locationData['longitude'] = longitude;
      if (latitude != null) locationData['latitude'] = latitude;
      if (isPrimary != null) locationData['isPrimary'] = isPrimary;

      final response = await _locationApi.updateLocation(id, locationData);
      if (response['success'] == true) {
        return LocationModel.fromJson(response['data']).toEntity();
      } else {
        throw Exception('Failed to update location: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }

  @override
  Future<void> deleteLocation(String locationId) async {
    try {
      final response = await _locationApi.deleteLocation(locationId);
      if (response['success'] != true) {
        throw Exception('Failed to delete location: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to delete location: $e');
    }
  }

  @override
  Future<LocationEntity?> getLocationById(String locationId) async {
    try {
      final response = await _locationApi.getLocation(locationId);
      if (response['success'] == true) {
        return LocationModel.fromJson(response['data']).toEntity();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<LocationEntity> changePrimaryLocation(String locationId) async {
    try {
      final response = await _locationApi.changePrimaryLocation(locationId);
      if (response['success'] == true) {
        return LocationModel.fromJson(response['data']).toEntity();
      } else {
        throw Exception('Failed to change primary location: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Failed to change primary location: $e');
    }
  }
}