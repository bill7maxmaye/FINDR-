import '../../../../core/network/api_client.dart';
import '../models/booking_model.dart';

abstract class BookingApi {
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData);
  Future<List<BookingModel>> getUserBookings();
  Future<BookingModel> getBookingById(String id);
  Future<BookingModel> updateBooking(String id, Map<String, dynamic> updates);
  Future<void> cancelBooking(String id);
  Future<List<BookingModel>> getBookingsByStatus(String status);
}

class BookingApiImpl implements BookingApi {
  final ApiClient _apiClient;

  BookingApiImpl(this._apiClient);

  @override
  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _apiClient.post('/bookings', bookingData);
      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create booking: ${e.toString()}');
    }
  }

  @override
  Future<List<BookingModel>> getUserBookings() async {
    try {
      final response = await _apiClient.get('/bookings');
      final List<dynamic> bookingsJson = response['bookings'] as List<dynamic>;
      return bookingsJson
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user bookings: ${e.toString()}');
    }
  }

  @override
  Future<BookingModel> getBookingById(String id) async {
    try {
      final response = await _apiClient.get('/bookings/$id');
      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch booking: ${e.toString()}');
    }
  }

  @override
  Future<BookingModel> updateBooking(String id, Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put('/bookings/$id', updates);
      return BookingModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update booking: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelBooking(String id) async {
    try {
      await _apiClient.delete('/bookings/$id');
    } catch (e) {
      throw Exception('Failed to cancel booking: ${e.toString()}');
    }
  }

  @override
  Future<List<BookingModel>> getBookingsByStatus(String status) async {
    try {
      final response = await _apiClient.get('/bookings?status=$status');
      final List<dynamic> bookingsJson = response['bookings'] as List<dynamic>;
      return bookingsJson
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings by status: ${e.toString()}');
    }
  }
}

