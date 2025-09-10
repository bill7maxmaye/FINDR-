import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking/core/di/service_locator.dart';
import 'package:service_booking/features/auth/data/datasources/auth_api.dart';
import 'package:service_booking/features/home/data/datasources/home_api.dart';
import 'package:service_booking/features/booking/data/datasources/booking_api.dart';
import 'package:service_booking/features/profile/data/datasources/profile_api.dart';

void main() {
  group('Dependency Injection Tests', () {
    setUp(() async {
      await init();
    });

    test('should register AuthApi', () {
      expect(sl.isRegistered<AuthApi>(), isTrue);
      expect(sl<AuthApi>(), isA<AuthApi>());
    });

    test('should register HomeApi', () {
      expect(sl.isRegistered<HomeApi>(), isTrue);
      expect(sl<HomeApi>(), isA<HomeApi>());
    });

    test('should register BookingApi', () {
      expect(sl.isRegistered<BookingApi>(), isTrue);
      expect(sl<BookingApi>(), isA<BookingApi>());
    });

    test('should register ProfileApi', () {
      expect(sl.isRegistered<ProfileApi>(), isTrue);
      expect(sl<ProfileApi>(), isA<ProfileApi>());
    });
  });
}

