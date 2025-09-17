import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class AddLocation {
  final LocationRepository _repository;

  AddLocation(this._repository);

  Future<LocationEntity> call({
    required String subCity,
    required String worada,
    required String name,
    required double longitude,
    required double latitude,
    bool isPrimary = false,
  }) async {
    return await _repository.addLocation(
      subCity: subCity,
      worada: worada,
      name: name,
      longitude: longitude,
      latitude: latitude,
      isPrimary: isPrimary,
    );
  }
}
