import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class UpdateLocation {
  final LocationRepository _repository;

  UpdateLocation(this._repository);

  Future<LocationEntity> call({
    required String id,
    String? subCity,
    String? worada,
    String? name,
    double? longitude,
    double? latitude,
    bool? isPrimary,
  }) async {
    return await _repository.updateLocation(
      id: id,
      subCity: subCity,
      worada: worada,
      name: name,
      longitude: longitude,
      latitude: latitude,
      isPrimary: isPrimary,
    );
  }
}
