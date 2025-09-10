import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ApiClient {
  ApiClient();

  late http.Client _client;
  String? _authToken;

  void initialize() {
    _client = http.Client();
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}$endpoint');
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}$endpoint');
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: json.encode(body),
          )
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}$endpoint');
      final response = await _client
          .put(
            uri,
            headers: _headers,
            body: json.encode(body),
          )
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.apiVersion}$endpoint');
      final response = await _client
          .delete(uri, headers: _headers)
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleException(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw HttpException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}',
      );
    }
  }

  Exception _handleException(dynamic error) {
    if (error is SocketException) {
      return Exception(AppConstants.networkErrorMessage);
    } else if (error is HttpException) {
      return Exception(AppConstants.serverErrorMessage);
    } else {
      return Exception(AppConstants.unknownErrorMessage);
    }
  }

  void dispose() {
    _client.close();
  }
}
