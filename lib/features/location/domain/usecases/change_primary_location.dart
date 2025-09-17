import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class ChangePrimaryLocation {
  final LocationRepository _repository;

  ChangePrimaryLocation(this._repository);

  Future<LocationEntity> call(String locationId) async {
    return await _repository.changePrimaryLocation(locationId);
  }
}
