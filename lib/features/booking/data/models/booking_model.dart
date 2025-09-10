import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.userId,
    required super.serviceId,
    required super.serviceName,
    required super.scheduledDate,
    required super.notes,
    required super.status,
    required super.totalAmount,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      notes: json['notes'] as String,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
      ),
      totalAmount: (json['total_amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'service_name': serviceName,
      'scheduled_date': scheduledDate.toIso8601String(),
      'notes': notes,
      'status': status.name,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      id: booking.id,
      userId: booking.userId,
      serviceId: booking.serviceId,
      serviceName: booking.serviceName,
      scheduledDate: booking.scheduledDate,
      notes: booking.notes,
      status: booking.status,
      totalAmount: booking.totalAmount,
      createdAt: booking.createdAt,
      updatedAt: booking.updatedAt,
    );
  }

  Booking toEntity() {
    return Booking(
      id: id,
      userId: userId,
      serviceId: serviceId,
      serviceName: serviceName,
      scheduledDate: scheduledDate,
      notes: notes,
      status: status,
      totalAmount: totalAmount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

