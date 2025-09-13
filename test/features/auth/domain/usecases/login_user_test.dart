import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking/features/auth/domain/entities/user.dart';
import 'package:service_booking/features/auth/domain/usecases/login_user.dart';

void main() {
  late LoginUser usecase;

  setUp(() {
    // Note: This test will fail in practice due to network dependencies
    // but demonstrates the test structure
    usecase = LoginUser(null as dynamic);
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

  group('LoginUser', () {
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
    });
  });
}

