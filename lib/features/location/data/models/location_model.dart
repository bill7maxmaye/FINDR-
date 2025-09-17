import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel extends LocationEntity {
  const LocationModel({
    required super.id,
    required super.subCity,
    required super.worada,
    required super.name,
    required super.longitude,
    required super.latitude,
    required super.isPrimary,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      id: entity.id,
      subCity: entity.subCity,
      worada: entity.worada,
      name: entity.name,
      longitude: entity.longitude,
      latitude: entity.latitude,
      isPrimary: entity.isPrimary,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  LocationEntity toEntity() {
    return LocationEntity(
      id: id,
      subCity: subCity,
      worada: worada,
      name: name,
      longitude: longitude,
      latitude: latitude,
      isPrimary: isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

