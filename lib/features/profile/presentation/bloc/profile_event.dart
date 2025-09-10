abstract class ProfileEvent {}

class ProfileLoadUser extends ProfileEvent {}

class ProfileUpdateProfile extends ProfileEvent {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;

  ProfileUpdateProfile({
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });
}

class ProfileChangePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  ProfileChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ProfileDeleteAccount extends ProfileEvent {}

class ProfileUploadImage extends ProfileEvent {
  final String imagePath;

  ProfileUploadImage({required this.imagePath});
}

