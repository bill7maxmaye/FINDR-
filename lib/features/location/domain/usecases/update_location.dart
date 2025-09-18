import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class UpdateLocation {
  final LocationRepository _locationRepository;

  UpdateLocation(this._locationRepository);

  Future<LocationEntity> call(UpdateLocationParams params) async {
    return await _locationRepository.updateLocation(
      id: params.id,
      subCity: params.subCity,
      worada: params.worada,
      name: params.name,
      longitude: params.longitude,
      latitude: params.latitude,
      isPrimary: params.isPrimary,
    );
  }
}

class UpdateLocationParams {
  final String id;
  final String? subCity;
  final String? worada;
  final String? name;
  final double? longitude;
  final double? latitude;
  final bool? isPrimary;

  UpdateLocationParams({
    required this.id,
    this.subCity,
    this.worada,
    this.name,
    this.longitude,
    this.latitude,
    this.isPrimary,
  });
}