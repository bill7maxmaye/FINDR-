enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final DateTime scheduledDate;
  final String notes;
  final BookingStatus status;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.scheduledDate,
    required this.notes,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  Booking copyWith({
    String? id,
    String? userId,
    String? serviceId,
    String? serviceName,
    DateTime? scheduledDate,
    String? notes,
    BookingStatus? status,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking &&
        other.id == id &&
        other.userId == userId &&
        other.serviceId == serviceId &&
        other.serviceName == serviceName &&
        other.scheduledDate == scheduledDate &&
        other.notes == notes &&
        other.status == status &&
        other.totalAmount == totalAmount &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        serviceId.hashCode ^
        serviceName.hashCode ^
        scheduledDate.hashCode ^
        notes.hashCode ^
        status.hashCode ^
        totalAmount.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, serviceId: $serviceId, serviceName: $serviceName, scheduledDate: $scheduledDate, notes: $notes, status: $status, totalAmount: $totalAmount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

