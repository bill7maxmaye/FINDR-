import '../../domain/entities/booking.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;

  BookingLoaded({required this.bookings});
}

class BookingDetailLoaded extends BookingState {
  final Booking booking;

  BookingDetailLoaded({required this.booking});
}

class BookingCreated extends BookingState {
  final Booking booking;

  BookingCreated({required this.booking});
}

class BookingUpdated extends BookingState {
  final Booking booking;

  BookingUpdated({required this.booking});
}

class BookingCancelled extends BookingState {}

class BookingError extends BookingState {
  final String message;

  BookingError({required this.message});
}

