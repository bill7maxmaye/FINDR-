import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final String subCity;
  final String worada;
  final String name;
  final double longitude;
  final double latitude;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LocationEntity({
    required this.id,
    required this.subCity,
    required this.worada,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.isPrimary,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        subCity,
        worada,
        name,
        longitude,
        latitude,
        isPrimary,
        createdAt,
        updatedAt,
      ];

  LocationEntity copyWith({
    String? id,
    String? subCity,
    String? worada,
    String? name,
    double? longitude,
    double? latitude,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      subCity: subCity ?? this.subCity,
      worada: worada ?? this.worada,
      name: name ?? this.name,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subCity': subCity,
      'worada': worada,
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json['id'] as String,
      subCity: json['subCity'] as String,
      worada: json['worada'] as String,
      name: json['name'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      isPrimary: json['isPrimary'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

