import '../repositories/location_repository.dart';

class DeleteLocation {
  final LocationRepository _repository;

  DeleteLocation(this._repository);

  Future<void> call(String locationId) async {
    await _repository.deleteLocation(locationId);
  }
}
