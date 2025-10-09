import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
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
      final res = await dio.post('/sign-in/email', data: {
        'email': email,
        'password': password,
        'callbackURL': '',
        'rememberMe': rememberMe,
      });

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        return res.data as Map<String, dynamic>;
      }
      throw Exception('Login failed (${res.statusCode})');
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
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
      final res = await dio.post('/sign-up/email', data: payload);
      print('Registration payload: $payload');
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
      await dio.post('/sign-out', data: {});
    } on DioException catch (e) {
      throw Exception('Logout failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getSession() async {
    try {
      final dio = await _client.instance;
      final res = await dio.get('/get-session');

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
      await dio.post('/forget-password', data: {
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
      await dio.post('/reset-password', data: {
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
      await dio.get('/verify-email', queryParameters: {
        'token': token,
      });
    } on DioException catch (e) {
      throw Exception('Email verification failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final dio = await _client.instance;
      await dio.post('/send-verification-email', data: {});
    } on DioException catch (e) {
      throw Exception('Resend verification email failed: ${e.response?.data ?? e.message}');
    }
  }
}
