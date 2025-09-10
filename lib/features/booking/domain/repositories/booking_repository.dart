import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking({
    required String serviceId,
    required DateTime scheduledDate,
    required String notes,
  });
  Future<List<Booking>> getUserBookings();
  Future<Booking> getBookingById(String id);
  Future<Booking> updateBooking(String id, {
    DateTime? scheduledDate,
    String? notes,
    BookingStatus? status,
  });
  Future<void> cancelBooking(String id);
  Future<List<Booking>> getBookingsByStatus(BookingStatus status);
}

