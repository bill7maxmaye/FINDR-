abstract class BookingEvent {}

class BookingLoadUserBookings extends BookingEvent {}

class BookingCreateBooking extends BookingEvent {
  final String serviceId;
  final DateTime scheduledDate;
  final String notes;

  BookingCreateBooking({
    required this.serviceId,
    required this.scheduledDate,
    required this.notes,
  });
}

class BookingUpdateBooking extends BookingEvent {
  final String id;
  final DateTime? scheduledDate;
  final String? notes;
  final String? status;

  BookingUpdateBooking({
    required this.id,
    this.scheduledDate,
    this.notes,
    this.status,
  });
}

class BookingCancelBooking extends BookingEvent {
  final String id;

  BookingCancelBooking({required this.id});
}

class BookingLoadBookingById extends BookingEvent {
  final String id;

  BookingLoadBookingById({required this.id});
}

