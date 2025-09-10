import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthApi {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(Map<String, dynamic> userData);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> refreshToken();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
  Future<void> resendVerificationEmail();
}

class AuthApiImpl implements AuthApi {
  final DioClient _client;

  AuthApiImpl(this._client);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final dio = await _client.instance;
      final res = await dio.post('/sign-in/email', data: {
        'email': email,
        'password': password,
      });

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;
        final userData = data['user'] as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': userData['id'],
          'email': userData['email'],
          'first_name': userData['name'] ?? '',
          'last_name': '',
          'created_at': userData['createdAt'],
          'updated_at': userData['updatedAt'],
          'is_email_verified': userData['emailVerified'] == true,
          'is_active': true,
        });
      }
      throw Exception('Login failed (${res.statusCode})');
    } on DioException catch (e) {
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<UserModel> register(Map<String, dynamic> userData) async {
    try {
      final dio = await _client.instance;
      final payload = {
        'name': (userData['first_name'] as String?) ?? (userData['name'] as String?),
        'email': userData['email'],
        'password': userData['password'],
        'rememberMe': true,
      };
      final res = await dio.post('/sign-up/email', data: payload);

      if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
        final data = res.data as Map<String, dynamic>;
        final u = data['user'] as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': u['id'],
          'email': u['email'],
          'first_name': (payload['name'] as String?)?.split(' ').first ?? '',
          'last_name': (payload['name'] as String?)?.split(' ').skip(1).join(' ') ?? '',
          'created_at': u['createdAt'],
          'updated_at': u['updatedAt'],
          'is_email_verified': u['emailVerified'] == true,
          'is_active': true,
        });
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
  Future<UserModel> getCurrentUser() async {
    // Better Auth OpenAPI excerpt provided does not include a /me endpoint.
    // We rely on locally cached user for now.
    throw Exception('getCurrentUser not supported by API spec');
  }

  @override
  Future<void> refreshToken() async {
    // Cookie-based sessions typically refresh server-side; no-op here.
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
