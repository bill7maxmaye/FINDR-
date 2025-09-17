import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call(LoginUserParams params) async {
    if (params.email.isEmpty) {
      throw Exception('Email is required');
    }
    if (params.password.isEmpty) {
      throw Exception('Password is required');
    }

    return await repository.login(params.email, params.password, rememberMe: params.rememberMe);
  }
}

class LoginUserParams {
  final String email;
  final String password;
  final bool rememberMe;

  LoginUserParams({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });
}

