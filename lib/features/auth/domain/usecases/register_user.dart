import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<User> call(RegisterUserParams params) async {
    if (params.email.isEmpty) {
      throw Exception('Email is required');
    }
    if (params.password.isEmpty) {
      throw Exception('Password is required');
    }
    if (params.name.isEmpty) {
      throw Exception('Name is required');
    }

    return await repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}

class RegisterUserParams {
  final String email;
  final String password;
  final String name;

  RegisterUserParams({
    required this.email,
    required this.password,
    required this.name,
  });
}

