import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking/features/auth/domain/entities/user.dart';
import 'package:service_booking/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:service_booking/features/auth/presentation/bloc/auth_event.dart';
import 'package:service_booking/features/auth/presentation/bloc/auth_state.dart';

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc();
  });

  tearDown(() {
    authBloc.close();
  });

  final tUser = User(
    id: '1',
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
    updatedAt: DateTime.parse('2023-01-01T00:00:00Z'),
    isEmailVerified: true,
    isActive: true,
  );

  group('AuthBloc', () {
    test('initial state should be AuthInitial', () {
      expect(authBloc.state, equals(AuthInitial()));
    });

    group('AuthLoginRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails due to network',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    group('AuthRegisterRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when registration fails due to network',
        build: () => authBloc,
        act: (bloc) => bloc.add(
          AuthRegisterRequested(
            email: 'test@example.com',
            password: 'password123',
            firstName: 'Test',
            lastName: 'User',
          ),
        ),
        expect: () => [
          AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });

    group('AuthLogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when logout fails due to network',
        build: () => authBloc,
        act: (bloc) => bloc.add(AuthLogoutRequested()),
        expect: () => [
          AuthLoading(),
          isA<AuthError>(),
        ],
      );
    });
  });
}

