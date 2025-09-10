import '../entities/service.dart';

abstract class HomeRepository {
  Future<List<Service>> getServices();
  Future<List<Service>> getServicesByCategory(String category);
  Future<List<String>> getCategories();
  Future<Service> getServiceById(String id);
  Future<List<Service>> searchServices(String query);
}

