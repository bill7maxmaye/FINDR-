import '../../../auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<User> getCurrentUser();
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  });
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> deleteAccount();
  Future<void> uploadProfileImage(String imagePath);
}
