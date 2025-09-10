import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_api.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApi _bookingApi;

  BookingRepositoryImpl(this._bookingApi);

  @override
  Future<Booking> createBooking({
    required String serviceId,
    required DateTime scheduledDate,
    required String notes,
  }) async {
    try {
      final bookingData = {
        'service_id': serviceId,
        'scheduled_date': scheduledDate.toIso8601String(),
        'notes': notes,
      };

      final bookingModel = await _bookingApi.createBooking(bookingData);
      return bookingModel.toEntity();
    } catch (e) {
      throw Exception('Failed to create booking: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getUserBookings() async {
    try {
      final bookingModels = await _bookingApi.getUserBookings();
      return bookingModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get user bookings: ${e.toString()}');
    }
  }

  @override
  Future<Booking> getBookingById(String id) async {
    try {
      final bookingModel = await _bookingApi.getBookingById(id);
      return bookingModel.toEntity();
    } catch (e) {
      throw Exception('Failed to get booking by id: ${e.toString()}');
    }
  }

  @override
  Future<Booking> updateBooking(String id, {
    DateTime? scheduledDate,
    String? notes,
    BookingStatus? status,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (scheduledDate != null) {
        updates['scheduled_date'] = scheduledDate.toIso8601String();
      }
      if (notes != null) {
        updates['notes'] = notes;
      }
      if (status != null) {
        updates['status'] = status.name;
      }

      final bookingModel = await _bookingApi.updateBooking(id, updates);
      return bookingModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update booking: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelBooking(String id) async {
    try {
      await _bookingApi.cancelBooking(id);
    } catch (e) {
      throw Exception('Failed to cancel booking: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookingsByStatus(BookingStatus status) async {
    try {
      final bookingModels = await _bookingApi.getBookingsByStatus(status.name);
      return bookingModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get bookings by status: ${e.toString()}');
    }
  }
}

