import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi _profileApi;

  ProfileRepositoryImpl(this._profileApi);

  @override
  Future<User> getCurrentUser() async {
    try {
      final userModel = await _profileApi.getCurrentUser();
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      final profileData = <String, dynamic>{};
      if (firstName != null) profileData['first_name'] = firstName;
      if (lastName != null) profileData['last_name'] = lastName;
      if (phoneNumber != null) profileData['phone_number'] = phoneNumber;

      final userModel = await _profileApi.updateProfile(profileData);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final passwordData = {
        'current_password': currentPassword,
        'new_password': newPassword,
      };

      await _profileApi.changePassword(passwordData);
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _profileApi.deleteAccount();
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  @override
  Future<void> uploadProfileImage(String imagePath) async {
    try {
      await _profileApi.uploadProfileImage(imagePath);
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }
}
