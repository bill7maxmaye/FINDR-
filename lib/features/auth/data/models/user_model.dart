import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.phoneNumber,
    super.profileImageUrl,
    required super.createdAt,
    required super.updatedAt,
    required super.isEmailVerified,
    required super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Support both our internal snake_case and backend camelCase keys
    final fullName = (json['name'] as String?)?.trim();
    String firstName = json['first_name'] as String? ?? '';
    String lastName = json['last_name'] as String? ?? '';
    if ((firstName.isEmpty && lastName.isEmpty) && fullName != null && fullName.isNotEmpty) {
      final parts = fullName.split(' ');
      firstName = parts.isNotEmpty ? parts.first : '';
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }

    final profileImageUrl = (json['profile_image_url'] as String?) ?? (json['image'] as String?);
    final createdAtStr = (json['created_at'] as String?) ?? (json['createdAt'] as String?);
    final updatedAtStr = (json['updated_at'] as String?) ?? (json['updatedAt'] as String?);
    final isEmailVerified = (json['is_email_verified'] as bool?) ?? (json['emailVerified'] as bool?) ?? false;
    final isActive = (json['is_active'] as bool?) ?? true;

    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: profileImageUrl,
      createdAt: createdAtStr != null ? DateTime.parse(createdAtStr) : DateTime.now(),
      updatedAt: updatedAtStr != null ? DateTime.parse(updatedAtStr) : DateTime.now(),
      isEmailVerified: isEmailVerified,
      isActive: isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_email_verified': isEmailVerified,
      'is_active': isActive,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phoneNumber: user.phoneNumber,
      profileImageUrl: user.profileImageUrl,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isEmailVerified: user.isEmailVerified,
      isActive: user.isActive,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isEmailVerified: isEmailVerified,
      isActive: isActive,
    );
  }
}

