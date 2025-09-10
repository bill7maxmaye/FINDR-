import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<User> call(UpdateProfileParams params) async {
    if (params.firstName != null && params.firstName!.isEmpty) {
      throw Exception('First name cannot be empty');
    }
    if (params.lastName != null && params.lastName!.isEmpty) {
      throw Exception('Last name cannot be empty');
    }

    return await repository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      phoneNumber: params.phoneNumber,
    );
  }
}

class UpdateProfileParams {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });
}
