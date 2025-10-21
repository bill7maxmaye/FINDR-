import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../models/user_model.dart';

abstract class AuthApi {
  Future<Map<String, dynamic>> login(String email, String password, {bool rememberMe = false});
  Future<Map<String, dynamic>> register(String name, String email, String password, {bool rememberMe = true});
  Future<void> logout();
  Future<Map<String, dynamic>?> getSession();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
  Future<void> resendVerificationEmail();
}

class AuthApiImpl implements AuthApi {
  final DioClient _client;

  AuthApiImpl(this._client);

  @override
  Future<Map<String, dynamic>> login(String email, String password, {bool rememberMe = false}) async {
    try {
      final dio = await _client.instance;
      
      final loginData = {
        'email': email,
        'password': password,
        'callbackURL': '',
        'rememberMe': rememberMe,
      };
      
      final res = await dio.post('/api/auth/sign-in/email', data: loginData);

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return res.data as Map<String, dynamic>;
      }
      
      // Handle non-200 status codes (like 401)
      if (res.data != null && res.data is Map<String, dynamic>) {
        final responseData = res.data as Map<String, dynamic>;
        
        String errorMessage = 'Login failed. Please try again.';
        
        // Extract error message from response
        if (responseData.containsKey('message') && responseData['message'] != null) {
          errorMessage = responseData['message'] as String;
        } else if (responseData.containsKey('code') && responseData['code'] == 'INVALID_EMAIL_OR_PASSWORD') {
          errorMessage = 'Invalid email or password';
        }
        
        throw AuthException(errorMessage);
      }
      
      throw AuthException('Login failed (${res.statusCode})');
    } on DioException catch (e) {
      // Extract specific error message from backend response
      String errorMessage = 'Login failed. Please try again.';
      
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;
        
        // Prioritize the backend's message field
        if (responseData.containsKey('message') && responseData['message'] != null) {
          errorMessage = responseData['message'] as String;
        } else if (responseData.containsKey('code') && responseData['code'] == 'INVALID_EMAIL_OR_PASSWORD') {
          errorMessage = 'Invalid email or password';
        }
      }
      
      throw AuthException(errorMessage);
    }
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password, {bool rememberMe = true}) async {
    try {
      final dio = await _client.instance;
      final payload = {
        'name': name,
        'email': email,
        'password': password,
        'image': '',
        'callbackURL': '',
        'rememberMe': rememberMe,
      };

    print('Collected Registration payload: $payload');

      final res = await dio.post('/api/auth/sign-up/email', data: payload);
      
      print('Registration response: ${res.data}');

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return res.data as Map<String, dynamic>;
      }
      throw Exception('Registration failed (${res.statusCode})');
    } on DioException catch (e) {
      throw Exception('Registration failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final dio = await _client.instance;
      await dio.post('/api/auth/sign-out', data: {});
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getSession() async {
    try {
      final dio = await _client.instance;
      final res = await dio.get('/api/auth/get-session');

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return res.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      // Session not found or expired
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final dio = await _client.instance;
      await dio.post('/api/auth/forget-password', data: {
        'email': email,
      });
    } on DioException catch (e) {
      throw Exception('Forgot password failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final dio = await _client.instance;
      await dio.post('/api/auth/reset-password', data: {
        'newPassword': newPassword,
        'token': token,
      });
    } on DioException catch (e) {
      throw Exception('Password reset failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      final dio = await _client.instance;
      print('Verifying email with token: $token');
      print('Verification URL: ${dio.options.baseUrl}/auth/verify-email');
      await dio.get('/auth/verify-email', queryParameters: {
        'token': token,
      });
    } on DioException catch (e) {
      print('Email verification error: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status: ${e.response?.statusCode}');
      throw Exception('Email verification failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final dio = await _client.instance;
      print('Sending verification email to: ${dio.options.baseUrl}/auth/send-verification-email');
      await dio.post('/auth/send-verification-email', data: {});
    } on DioException catch (e) {
      print('Resend verification email error: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status: ${e.response?.statusCode}');
      throw Exception('Resend verification email failed: ${e.response?.data ?? e.message}');
    }
  }
}
