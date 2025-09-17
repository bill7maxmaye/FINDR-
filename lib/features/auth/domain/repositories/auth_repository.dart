import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password, {bool rememberMe = false});
  Future<User> register({
    required String email,
    required String password,
    required String name,
    bool rememberMe = true,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> saveUser(User user);
  Future<void> clearUser();
  Future<bool> isLoggedIn();
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> verifyEmail(String token);
  Future<void> resendVerificationEmail();
}

