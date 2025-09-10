import '../../../../core/network/api_client.dart';
import '../models/service_model.dart';

abstract class HomeApi {
  Future<List<ServiceModel>> getServices();
  Future<List<ServiceModel>> getServicesByCategory(String category);
  Future<List<String>> getCategories();
  Future<ServiceModel> getServiceById(String id);
  Future<List<ServiceModel>> searchServices(String query);
}

class HomeApiImpl implements HomeApi {
  final ApiClient _apiClient;

  HomeApiImpl(this._apiClient);

  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final response = await _apiClient.get('/services');
      final List<dynamic> servicesJson = response['services'] as List<dynamic>;
      return servicesJson
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch services: ${e.toString()}');
    }
  }

  @override
  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    try {
      final response = await _apiClient.get('/services?category=$category');
      final List<dynamic> servicesJson = response['services'] as List<dynamic>;
      return servicesJson
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch services by category: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _apiClient.get('/services/categories');
      return List<String>.from(response['categories'] as List<dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<ServiceModel> getServiceById(String id) async {
    try {
      final response = await _apiClient.get('/services/$id');
      return ServiceModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch service: ${e.toString()}');
    }
  }

  @override
  Future<List<ServiceModel>> searchServices(String query) async {
    try {
      final response = await _apiClient.get('/services/search?q=$query');
      final List<dynamic> servicesJson = response['services'] as List<dynamic>;
      return servicesJson
          .map((json) => ServiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search services: ${e.toString()}');
    }
  }
}

