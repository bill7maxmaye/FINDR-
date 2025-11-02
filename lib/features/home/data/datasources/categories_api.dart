import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class CategoriesApi {
  final DioClient _dioClient = DioClient();

  /// Fetch all categories with their subcategories
  Future<Map<String, dynamic>> getAllCategories() async {
    try {
      final dio = await _dioClient.instance;
      print('Categories API: Fetching all categories...');
      print('Categories API URL: ${dio.options.baseUrl}/categories');
      
      final response = await dio.get('/api/categories');
      
      print('Categories response status: ${response.statusCode}');
      print('Categories response data: ${response.data}');
      print('Categories response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      
      throw Exception('Failed to fetch categories (${response.statusCode})');
    } on DioException catch (e) {
      print('Categories DioException: ${e.message}');
      print('Categories response data: ${e.response?.data}');
      print('Categories response status: ${e.response?.statusCode}');
      throw Exception('Failed to fetch categories: ${e.message}');
    }
  }

  /// Fetch all subcategories for a specific category
  Future<Map<String, dynamic>> getSubcategoriesByCategory(String categoryId) async {
    try {
      final dio = await _dioClient.instance;
      print('Categories API: Fetching subcategories for category: $categoryId');
      print('Categories API URL: ${dio.options.baseUrl}/categories/$categoryId/subcategories');
      
      final response = await dio.get('/api/categories/$categoryId/subcategories');
      
      print('Subcategories response status: ${response.statusCode}');
      print('Subcategories response data: ${response.data}');
      print('Subcategories response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      
      throw Exception('Failed to fetch subcategories (${response.statusCode})');
    } on DioException catch (e) {
      print('Subcategories DioException: ${e.message}');
      print('Subcategories response data: ${e.response?.data}');
      print('Subcategories response status: ${e.response?.statusCode}');
      throw Exception('Failed to fetch subcategories: ${e.message}');
    }
  }
}
