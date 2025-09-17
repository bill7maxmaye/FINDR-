import '../entities/location_entity.dart';

abstract class LocationRepository {
  Future<List<LocationEntity>> getAllLocations();
  Future<LocationEntity> addLocation({
    required String subCity,
    required String worada,
    required String name,
    required double longitude,
    required double latitude,
    bool isPrimary = false,
  });
  Future<LocationEntity> updateLocation({
    required String id,
    String? subCity,
    String? worada,
    String? name,
    double? longitude,
    double? latitude,
    bool? isPrimary,
  });
  Future<void> deleteLocation(String locationId);
  Future<LocationEntity?> getLocationById(String locationId);
  Future<LocationEntity> changePrimaryLocation(String locationId);
}

