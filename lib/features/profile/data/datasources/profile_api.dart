import '../../../../core/network/api_client.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ProfileApi {
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(Map<String, dynamic> profileData);
  Future<void> changePassword(Map<String, dynamic> passwordData);
  Future<void> deleteAccount();
  Future<void> uploadProfileImage(String imagePath);
}

class ProfileApiImpl implements ProfileApi {
  final ApiClient _apiClient;

  ProfileApiImpl(this._apiClient);

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/profile');
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.put('/profile', profileData);
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword(Map<String, dynamic> passwordData) async {
    try {
      await _apiClient.put('/profile/password', passwordData);
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _apiClient.delete('/profile');
    } catch (e) {
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  @override
  Future<void> uploadProfileImage(String imagePath) async {
    try {
      // This would typically involve multipart form data upload
      // For now, we'll just make a placeholder API call
      await _apiClient.post('/profile/image', {'image_path': imagePath});
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }
}
