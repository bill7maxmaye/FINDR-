import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking.dart';
import '../../data/datasources/booking_api.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/create_booking.dart';
import '../../../../core/network/api_client.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  late final CreateBooking _createBooking;
  late final BookingRepository _bookingRepository;

  BookingBloc() : super(BookingInitial()) {
    _initializeDependencies();
    on<BookingLoadUserBookings>(_onLoadUserBookings);
    on<BookingCreateBooking>(_onCreateBooking);
    on<BookingUpdateBooking>(_onUpdateBooking);
    on<BookingCancelBooking>(_onCancelBooking);
    on<BookingLoadBookingById>(_onLoadBookingById);
  }

  void _initializeDependencies() {
    final bookingApi = BookingApiImpl(ApiClient());
    _bookingRepository = BookingRepositoryImpl(bookingApi);
    _createBooking = CreateBooking(_bookingRepository);
  }

  Future<void> _onLoadUserBookings(
    BookingLoadUserBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepository.getUserBookings();
      emit(BookingLoaded(bookings: bookings));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onCreateBooking(
    BookingCreateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final booking = await _createBooking.call(CreateBookingParams(
        serviceId: event.serviceId,
        scheduledDate: event.scheduledDate,
        notes: event.notes,
      ));
      emit(BookingCreated(booking: booking));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onUpdateBooking(
    BookingUpdateBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final booking = await _bookingRepository.updateBooking(
        event.id,
        scheduledDate: event.scheduledDate,
        notes: event.notes,
        status: event.status != null 
            ? BookingStatus.values.firstWhere((e) => e.name == event.status)
            : null,
      );
      emit(BookingUpdated(booking: booking));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onCancelBooking(
    BookingCancelBooking event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      await _bookingRepository.cancelBooking(event.id);
      emit(BookingCancelled());
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }

  Future<void> _onLoadBookingById(
    BookingLoadBookingById event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final booking = await _bookingRepository.getBookingById(event.id);
      emit(BookingDetailLoaded(booking: booking));
    } catch (e) {
      emit(BookingError(message: e.toString()));
    }
  }
}
