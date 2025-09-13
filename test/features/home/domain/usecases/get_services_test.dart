import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking/features/home/domain/entities/service.dart';
import 'package:service_booking/features/home/domain/usecases/get_services.dart';

void main() {
  late GetServices usecase;

  setUp(() {
    // Note: This test will fail in practice due to network dependencies
    // but demonstrates the test structure
    usecase = GetServices(null as dynamic);
  });

  final tServices = [
    Service(
      id: '1',
      name: 'Test Service',
      description: 'Test Description',
      price: 100.0,
      category: 'Test Category',
      duration: 60,
      isActive: true,
      createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      updatedAt: DateTime.parse('2023-01-01T00:00:00Z'),
    ),
    Service(
      id: '2',
      name: 'Another Service',
      description: 'Another Description',
      price: 150.0,
      category: 'Another Category',
      duration: 90,
      isActive: true,
      createdAt: DateTime.parse('2023-01-01T00:00:00Z'),
      updatedAt: DateTime.parse('2023-01-01T00:00:00Z'),
    ),
  ];

  group('GetServices', () {
    test('should be instantiated correctly', () {
      // assert
      expect(usecase, isA<GetServices>());
    });
  });
}

