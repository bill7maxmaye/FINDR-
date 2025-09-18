import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class ChangePrimaryLocation {
  final LocationRepository _locationRepository;

  ChangePrimaryLocation(this._locationRepository);

  Future<LocationEntity> call(String locationId) async {
    return await _locationRepository.changePrimaryLocation(locationId);
  }
}