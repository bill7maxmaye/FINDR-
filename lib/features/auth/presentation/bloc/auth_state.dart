import '../../domain/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated({required this.user});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthEmailSent extends AuthState {
  final String message;

  AuthEmailSent({required this.message});
}

class AuthPasswordReset extends AuthState {
  final String message;

  AuthPasswordReset({required this.message});
}

class AuthEmailVerified extends AuthState {
  final String message;

  AuthEmailVerified({required this.message});
}

class AuthVerificationEmailSent extends AuthState {
  final String message;
  AuthVerificationEmailSent({required this.message});
}

