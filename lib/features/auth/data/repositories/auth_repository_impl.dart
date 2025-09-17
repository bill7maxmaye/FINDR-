import '../../../../core/constants.dart';
import '../../../../core/utils/storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final StorageService _storageService;

  AuthRepositoryImpl(this._authApi, this._storageService);

  @override
  Future<User> login(String email, String password, {bool rememberMe = false}) async {
    try {
      final response = await _authApi.login(email, password, rememberMe: rememberMe);
      final userData = response['user'] as Map<String, dynamic>;
      final userModel = UserModel.fromJson({
        'id': userData['id'],
        'email': userData['email'],
        'first_name': userData['name'] ?? '',
        'last_name': '',
        'created_at': userData['createdAt'],
        'updated_at': userData['updatedAt'],
        'is_email_verified': userData['emailVerified'] == true,
        'is_active': true,
      });
      final user = userModel.toEntity();
      
      // Save user profile locally. Session is cookie-based.
      await _storageService.setJson(AppConstants.userKey, userModel.toJson());
      
      return user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String name,
    bool rememberMe = true,
  }) async {
    try {
      final response = await _authApi.register(name, email, password, rememberMe: rememberMe);
      final userData = response['user'] as Map<String, dynamic>;
      final userModel = UserModel.fromJson({
        'id': userData['id'],
        'email': userData['email'],
        'first_name': userData['name'] ?? '',
        'last_name': '',
        'created_at': userData['createdAt'],
        'updated_at': userData['updatedAt'],
        'is_email_verified': userData['emailVerified'] == true,
        'is_active': true,
      });
      final user = userModel.toEntity();
      
      // Save user profile locally. Session is cookie-based.
      await _storageService.setJson(AppConstants.userKey, userModel.toJson());
      
      return user;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (e) {
      // Continue with local cleanup even if API call fails
    } finally {
      // Clear local storage
      await _storageService.removeString(AppConstants.userKey);
      await _storageService.removeString(AppConstants.tokenKey);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // First try to get from local storage
      final userJson = _storageService.getJson(AppConstants.userKey);
      if (userJson != null) {
        return UserModel.fromJson(userJson).toEntity();
      }

      // If not in local storage, try to fetch session from API
      final sessionData = await _authApi.getSession();
      if (sessionData != null && sessionData['user'] != null) {
        final userData = sessionData['user'] as Map<String, dynamic>;
        final userModel = UserModel.fromJson({
          'id': userData['id'],
          'email': userData['email'],
          'first_name': userData['name'] ?? '',
          'last_name': '',
          'created_at': userData['createdAt'],
          'updated_at': userData['updatedAt'],
          'is_email_verified': userData['emailVerified'] == true,
          'is_active': true,
        });
        final user = userModel.toEntity();
        
        // Save to local storage for future use
        await _storageService.setJson(AppConstants.userKey, userModel.toJson());
        
        return user;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    final userModel = UserModel.fromEntity(user);
    await _storageService.setJson(AppConstants.userKey, userModel.toJson());
  }

  @override
  Future<void> clearUser() async {
    await _storageService.removeString(AppConstants.userKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }


  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authApi.forgotPassword(email);
    } catch (e) {
      throw Exception('Forgot password request failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _authApi.resetPassword(token, newPassword);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyEmail(String token) async {
    try {
      await _authApi.verifyEmail(token);
    } catch (e) {
      throw Exception('Email verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      await _authApi.resendVerificationEmail();
    } catch (e) {
      throw Exception('Resend verification email failed: ${e.toString()}');
    }
  }
}
