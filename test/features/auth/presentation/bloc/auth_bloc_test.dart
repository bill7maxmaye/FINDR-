import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:service_booking/features/auth/domain/entities/user.dart';
import 'package:service_booking/features/auth/domain/repositories/auth_repository.dart';
import 'package:service_booking/features/auth/domain/usecases/login_user.dart';
import 'package:service_booking/features/auth/domain/usecases/register_user.dart';
import 'package:service_booking/features/auth/domain/usecases/logout_user.dart';
import 'package:service_booking/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:service_booking/features/auth/presentation/bloc/auth_event.dart';
import 'package:service_booking/features/auth/presentation/bloc/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  LoginUser,
  RegisterUser,
  LogoutUser,
  AuthRepository,
])
void main() {
  late AuthBloc authBloc;
  late MockLoginUser mockLoginUser;
  late MockRegisterUser mockRegisterUser;
  late MockLogoutUser mockLogoutUser;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockLoginUser = MockLoginUser();
    mockRegisterUser = MockRegisterUser();
    mockLogoutUser = MockLogoutUser();
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(
      loginUser: mockLoginUser,
      registerUser: mockRegisterUser,
      logoutUser: mockLogoutUser,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  const tUser = User(
    id: '1',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    createdAt: '2023-01-01T00:00:00Z',
    updatedAt: '2023-01-01T00:00:00Z',
    isEmailVerified: true,
    isActive: true,
  );

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when login is successful',
        build: () {
          when(mockLoginUser.call(any))
              .thenAnswer((_) async => tUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          AuthLoading(),
          AuthAuthenticated(user: tUser),
        ],
        verify: (_) {
          verify(mockLoginUser.call(any)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(mockLoginUser.call(any))
              .thenThrow(Exception('Login failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          AuthLoading(),
          AuthError(message: 'Exception: Login failed'),
        ],
        verify: (_) {
          verify(mockLoginUser.call(any)).called(1);
        },
      );
    });

    group('AuthRegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthAuthenticated] when registration is successful',
        build: () {
          when(mockRegisterUser.call(any))
              .thenAnswer((_) async => tUser);
          return authBloc;
        },
        act: (bloc) => bloc.add(
          const AuthRegisterRequested(
            email: 'test@example.com',
            password: 'password123',
            firstName: 'Test',
            lastName: 'User',
          ),
        ),
        expect: () => [
          AuthLoading(),
          AuthAuthenticated(user: tUser),
        ],
        verify: (_) {
          verify(mockRegisterUser.call(any)).called(1);
        },
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when logout is successful',
        build: () {
          when(mockLogoutUser.call())
              .thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthLogoutRequested()),
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
        verify: (_) {
          verify(mockLogoutUser.call()).called(1);
        },
      );
    });
  });
}

