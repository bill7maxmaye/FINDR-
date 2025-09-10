import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;

  CreateBooking(this.repository);

  Future<Booking> call(CreateBookingParams params) async {
    if (params.serviceId.isEmpty) {
      throw Exception('Service ID is required');
    }
    if (params.scheduledDate.isBefore(DateTime.now())) {
      throw Exception('Scheduled date cannot be in the past');
    }

    return await repository.createBooking(
      serviceId: params.serviceId,
      scheduledDate: params.scheduledDate,
      notes: params.notes,
    );
  }
}

class CreateBookingParams {
  final String serviceId;
  final DateTime scheduledDate;
  final String notes;

  CreateBookingParams({
    required this.serviceId,
    required this.scheduledDate,
    required this.notes,
  });
}

