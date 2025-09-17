import '../entities/location_entity.dart';
import '../repositories/location_repository.dart';

class GetAllLocations {
  final LocationRepository _repository;

  GetAllLocations(this._repository);

  Future<List<LocationEntity>> call() async {
    return await _repository.getAllLocations();
  }
}
