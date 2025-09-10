abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({
    required this.email,
    required this.password,
  });
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthCheckStatusRequested extends AuthEvent {}

class AuthRefreshTokenRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;

  AuthForgotPasswordRequested({required this.email});
}

class AuthResetPasswordRequested extends AuthEvent {
  final String token;
  final String newPassword;

  AuthResetPasswordRequested({
    required this.token,
    required this.newPassword,
  });
}

class AuthVerifyEmailRequested extends AuthEvent {
  final String token;

  AuthVerifyEmailRequested({required this.token});
}

class AuthResendVerificationRequested extends AuthEvent {}

class AuthResendVerificationEmailRequested extends AuthEvent {
  final String email;
  final String? callbackURL;

  AuthResendVerificationEmailRequested({required this.email, this.callbackURL});
}

class AuthRememberMeChanged extends AuthEvent {
  final bool rememberMe;
  AuthRememberMeChanged(this.rememberMe);
}

