import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

abstract class LocationApi {
  Future<Map<String, dynamic>> addLocation(Map<String, dynamic> locationData);
  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> locationData);
  Future<Map<String, dynamic>> deleteLocation(String id);
  Future<Map<String, dynamic>> getLocation(String id);
  Future<Map<String, dynamic>> getAllLocations();
  Future<Map<String, dynamic>> changePrimaryLocation(String id);
}

class LocationApiImpl implements LocationApi {
  final DioClient _dioClient;

  LocationApiImpl(this._dioClient);

  // TODO: Replace with your device-reachable URL
  static const String baseUrl = 'http://192.168.1.7:3000/api/location';

  @override
  Future<Map<String, dynamic>> addLocation(Map<String, dynamic> locationData) async {
    try {
      final dio = await _dioClient.instance;
      // Override base URL for this request
      final response = await dio.post(
        'http://192.168.1.7:3000/api/location/add',
        data: locationData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to add location: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to add location: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> updateLocation(String id, Map<String, dynamic> locationData) async {
    try {
      final dio = await _dioClient.instance;
      final response = await dio.patch(
        'http://192.168.1.7:3000/api/location/$id',
        data: locationData,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update location: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to update location: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> deleteLocation(String id) async {
    try {
      final dio = await _dioClient.instance;
      final response = await dio.delete('http://192.168.1.7:3000/api/location/$id');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to delete location: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to delete location: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getLocation(String id) async {
    try {
      final dio = await _dioClient.instance;
      final response = await dio.get('http://192.168.1.7:3000/api/location/$id');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get location: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to get location: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getAllLocations() async {
    try {
      final dio = await _dioClient.instance;
      print('Making request to: http://192.168.1.7:3000/api/location');
      print('Request headers: ${dio.options.headers}');

      final response = await dio.get('http://192.168.1.7:3000/api/location');

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get locations: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status: ${e.response?.statusCode}');
      
      if (e.response != null) {
        throw Exception('Failed to get locations: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> changePrimaryLocation(String id) async {
    try {
      final dio = await _dioClient.instance;
      final response = await dio.patch('http://192.168.1.7:3000/api/location/$id/change-primary');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to change primary location: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to change primary location: ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
