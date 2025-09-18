import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetLocationById {
  final LocationRepository _locationRepository;

  GetLocationById(this._locationRepository);

  Future<LocationEntity?> call(String locationId) async {
    return await _locationRepository.getLocationById(locationId);
  }
}