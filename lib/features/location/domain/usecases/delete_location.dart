import '../repositories/location_repository.dart';

class DeleteLocation {
  final LocationRepository _locationRepository;

  DeleteLocation(this._locationRepository);

  Future<void> call(String locationId) async {
    return await _locationRepository.deleteLocation(locationId);
  }
}