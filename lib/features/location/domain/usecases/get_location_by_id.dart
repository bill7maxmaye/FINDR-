import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetLocationById {
  final LocationRepository _repository;

  GetLocationById(this._repository);

  Future<LocationEntity?> call(String locationId) async {
    return await _repository.getLocationById(locationId);
  }
}
