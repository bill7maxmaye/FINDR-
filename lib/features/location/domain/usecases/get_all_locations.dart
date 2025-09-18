import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetAllLocations {
  final LocationRepository _locationRepository;

  GetAllLocations(this._locationRepository);

  Future<List<LocationEntity>> call() async {
    return await _locationRepository.getAllLocations();
  }
}