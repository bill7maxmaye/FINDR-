import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:service_booking/features/auth/domain/entities/user.dart';
import 'package:service_booking/features/auth/domain/repositories/auth_repository.dart';
import 'package:service_booking/features/auth/domain/usecases/login_user.dart';

import 'login_user_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late LoginUser usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUser(mockAuthRepository);
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

  group('LoginUser', () {
    test('should return a user when login is successful', () async {
      // arrange
      when(mockAuthRepository.login('test@example.com', 'password123'))
          .thenAnswer((_) async => tUser);

      // act
      final result = await usecase.call(
        const LoginUserParams(
          email: 'test@example.com',
          password: 'password123',
        ),
      );

      // assert
      expect(result, equals(tUser));
      verify(mockAuthRepository.login('test@example.com', 'password123'));
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should throw exception when email is empty', () async {
      // act & assert
      expect(
        () => usecase.call(
          const LoginUserParams(
            email: '',
            password: 'password123',
          ),
        ),
        throwsA(isA<Exception>()),
      );
      verifyZeroInteractions(mockAuthRepository);
    });

    test('should throw exception when password is empty', () async {
      // act & assert
      expect(
        () => usecase.call(
          const LoginUserParams(
            email: 'test@example.com',
            password: '',
          ),
        ),
        throwsA(isA<Exception>()),
      );
      verifyZeroInteractions(mockAuthRepository);
    });
  });
}

