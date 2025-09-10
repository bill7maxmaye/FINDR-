import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
        expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(Validators.validateEmail('test+tag@example.org'), isNull);
      });

      test('should return error message for invalid email', () {
        expect(Validators.validateEmail(''), equals('Email is required'));
        expect(Validators.validateEmail('invalid'), equals('Please enter a valid email address'));
        expect(Validators.validateEmail('test@'), equals('Please enter a valid email address'));
        expect(Validators.validateEmail('@example.com'), equals('Please enter a valid email address'));
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        expect(Validators.validatePassword('Password123'), isNull);
        expect(Validators.validatePassword('MySecurePass1'), isNull);
      });

      test('should return error message for invalid password', () {
        expect(Validators.validatePassword(''), equals('Password is required'));
        expect(Validators.validatePassword('short'), equals('Password must be at least 8 characters long'));
        expect(Validators.validatePassword('nouppercase123'), equals('Password must contain at least one uppercase letter'));
        expect(Validators.validatePassword('NOLOWERCASE123'), equals('Password must contain at least one lowercase letter'));
        expect(Validators.validatePassword('NoNumbers'), equals('Password must contain at least one number'));
      });
    });

    group('validateName', () {
      test('should return null for valid name', () {
        expect(Validators.validateName('John'), isNull);
        expect(Validators.validateName('Mary Jane'), isNull);
        expect(Validators.validateName('O\'Connor'), isNull);
      });

      test('should return error message for invalid name', () {
        expect(Validators.validateName(''), equals('Name is required'));
        expect(Validators.validateName('A'), equals('Name must be at least 2 characters long'));
        expect(Validators.validateName('John123'), equals('Name can only contain letters and spaces'));
        expect(Validators.validateName('John@Doe'), equals('Name can only contain letters and spaces'));
      });
    });

    group('validatePhoneNumber', () {
      test('should return null for valid phone number', () {
        expect(Validators.validatePhoneNumber('1234567890'), isNull);
        expect(Validators.validatePhoneNumber('+1-234-567-8900'), isNull);
        expect(Validators.validatePhoneNumber('(123) 456-7890'), isNull);
      });

      test('should return error message for invalid phone number', () {
        expect(Validators.validatePhoneNumber(''), equals('Phone number is required'));
        expect(Validators.validatePhoneNumber('123'), equals('Phone number must be at least 10 digits'));
        expect(Validators.validatePhoneNumber('12345678901234567890'), equals('Phone number must be less than 15 digits'));
      });
    });

    group('validateConfirmPassword', () {
      test('should return null when passwords match', () {
        expect(Validators.validateConfirmPassword('password123', 'password123'), isNull);
      });

      test('should return error message when passwords do not match', () {
        expect(Validators.validateConfirmPassword('password123', 'password456'), equals('Passwords do not match'));
        expect(Validators.validateConfirmPassword('', 'password123'), equals('Please confirm your password'));
      });
    });
  });
}

