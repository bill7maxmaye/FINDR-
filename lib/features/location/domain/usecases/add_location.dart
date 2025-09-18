import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class AddLocation {
  final LocationRepository _locationRepository;

  AddLocation(this._locationRepository);

  Future<LocationEntity> call(AddLocationParams params) async {
    return await _locationRepository.addLocation(
      subCity: params.subCity,
      worada: params.worada,
      name: params.name,
      longitude: params.longitude,
      latitude: params.latitude,
      isPrimary: params.isPrimary,
    );
  }
}

class AddLocationParams {
  final String subCity;
  final String worada;
  final String name;
  final double longitude;
  final double latitude;
  final bool isPrimary;

  AddLocationParams({
    required this.subCity,
    required this.worada,
    required this.name,
    required this.longitude,
    required this.latitude,
    this.isPrimary = false,
  });
}