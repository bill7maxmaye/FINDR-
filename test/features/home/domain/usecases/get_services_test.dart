import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:service_booking/features/home/domain/entities/service.dart';
import 'package:service_booking/features/home/domain/repositories/home_repository.dart';
import 'package:service_booking/features/home/domain/usecases/get_services.dart';

import 'get_services_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late GetServices usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = GetServices(mockHomeRepository);
  });

  const tServices = [
    Service(
      id: '1',
      name: 'Test Service',
      description: 'Test Description',
      price: 100.0,
      category: 'Test Category',
      duration: 60,
      isActive: true,
      createdAt: '2023-01-01T00:00:00Z',
      updatedAt: '2023-01-01T00:00:00Z',
    ),
    Service(
      id: '2',
      name: 'Another Service',
      description: 'Another Description',
      price: 150.0,
      category: 'Another Category',
      duration: 90,
      isActive: true,
      createdAt: '2023-01-01T00:00:00Z',
      updatedAt: '2023-01-01T00:00:00Z',
    ),
  ];

  group('GetServices', () {
    test('should return a list of services when successful', () async {
      // arrange
      when(mockHomeRepository.getServices())
          .thenAnswer((_) async => tServices);

      // act
      final result = await usecase.call();

      // assert
      expect(result, equals(tServices));
      verify(mockHomeRepository.getServices());
      verifyNoMoreInteractions(mockHomeRepository);
    });

    test('should return empty list when no services available', () async {
      // arrange
      when(mockHomeRepository.getServices())
          .thenAnswer((_) async => <Service>[]);

      // act
      final result = await usecase.call();

      // assert
      expect(result, isEmpty);
      verify(mockHomeRepository.getServices());
      verifyNoMoreInteractions(mockHomeRepository);
    });
  });
}

