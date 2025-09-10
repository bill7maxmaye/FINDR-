import '../../domain/entities/service.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_api.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApi _homeApi;

  HomeRepositoryImpl(this._homeApi);

  @override
  Future<List<Service>> getServices() async {
    try {
      final serviceModels = await _homeApi.getServices();
      return serviceModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get services: ${e.toString()}');
    }
  }

  @override
  Future<List<Service>> getServicesByCategory(String category) async {
    try {
      final serviceModels = await _homeApi.getServicesByCategory(category);
      return serviceModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get services by category: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await _homeApi.getCategories();
    } catch (e) {
      throw Exception('Failed to get categories: ${e.toString()}');
    }
  }

  @override
  Future<Service> getServiceById(String id) async {
    try {
      final serviceModel = await _homeApi.getServiceById(id);
      return serviceModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get service by id: ${e.toString()}');
    }
  }

  @override
  Future<List<Service>> searchServices(String query) async {
    try {
      final serviceModels = await _homeApi.searchServices(query);
      return serviceModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search services: ${e.toString()}');
    }
  }
}

