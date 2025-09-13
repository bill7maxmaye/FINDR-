import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final LoginUser _loginUser;
  late final RegisterUser _registerUser;
  late final LogoutUser _logoutUser;
  late final AuthRepository _authRepository;

  AuthBloc() : super(AuthInitial()) {
    _initializeDependencies();
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatusRequested>(_onCheckStatusRequested);
    on<AuthRefreshTokenRequested>(_onRefreshTokenRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthVerifyEmailRequested>(_onVerifyEmailRequested);
    on<AuthResendVerificationRequested>(_onResendVerificationRequested);
    on<AuthResendVerificationEmailRequested>(_onResendVerificationEmailRequested);
  }

  void _initializeDependencies() {
    final dioClient = DioClient();
    final storageService = StorageService();
    final authApi = AuthApiImpl(dioClient);
    _authRepository = AuthRepositoryImpl(authApi, storageService);
    _loginUser = LoginUser(_authRepository);
    _registerUser = RegisterUser(_authRepository);
    _logoutUser = LogoutUser(_authRepository);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUser.call(LoginUserParams(
        email: event.email,
        password: event.password,
      ));
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _registerUser.call(RegisterUserParams(
        name: event.firstName,
        email: event.email,
        password: event.password,
         // using full name from UI
      ));
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _logoutUser.call();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onRefreshTokenRequested(
    AuthRefreshTokenRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.refreshToken();
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.forgotPassword(event.email);
      emit(AuthEmailSent(message: 'Password reset email sent'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.resetPassword(event.token, event.newPassword);
      emit(AuthPasswordReset(message: 'Password reset successful'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onVerifyEmailRequested(
    AuthVerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.verifyEmail(event.token);
      emit(AuthEmailVerified(message: 'Email verified successfully'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResendVerificationRequested(
    AuthResendVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.resendVerificationEmail();
      emit(AuthEmailSent(message: 'Verification email sent'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onResendVerificationEmailRequested(
    AuthResendVerificationEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.resendVerificationEmail();
      emit(AuthVerificationEmailSent(message: 'Verification email sent'));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}

