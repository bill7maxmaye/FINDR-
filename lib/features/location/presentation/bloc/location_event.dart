import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocations extends LocationEvent {
  const LoadLocations();
}

class AddLocationEvent extends LocationEvent {
  final String subCity;
  final String worada;
  final String name;
  final double longitude;
  final double latitude;
  final bool isPrimary;

  const AddLocationEvent({
    required this.subCity,
    required this.worada,
    required this.name,
    required this.longitude,
    required this.latitude,
    this.isPrimary = false,
  });

  @override
  List<Object?> get props => [subCity, worada, name, longitude, latitude, isPrimary];
}

class UpdateLocationEvent extends LocationEvent {
  final String id;
  final String? subCity;
  final String? worada;
  final String? name;
  final double? longitude;
  final double? latitude;
  final bool? isPrimary;

  const UpdateLocationEvent({
    required this.id,
    this.subCity,
    this.worada,
    this.name,
    this.longitude,
    this.latitude,
    this.isPrimary,
  });

  @override
  List<Object?> get props => [id, subCity, worada, name, longitude, latitude, isPrimary];
}

class DeleteLocationEvent extends LocationEvent {
  final String locationId;

  const DeleteLocationEvent(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class SetPrimaryLocation extends LocationEvent {
  final String locationId;

  const SetPrimaryLocation(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class ClearError extends LocationEvent {
  const ClearError();
}
