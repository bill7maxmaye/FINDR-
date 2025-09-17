import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllLocations extends LocationEvent {
  const LoadAllLocations();
}

class AddLocation extends LocationEvent {
  final String subCity;
  final String worada;
  final String name;
  final double longitude;
  final double latitude;
  final bool isPrimary;

  const AddLocation({
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

class UpdateLocation extends LocationEvent {
  final String id;
  final String? subCity;
  final String? worada;
  final String? name;
  final double? longitude;
  final double? latitude;
  final bool? isPrimary;

  const UpdateLocation({
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

class DeleteLocation extends LocationEvent {
  final String locationId;

  const DeleteLocation(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class ChangePrimaryLocation extends LocationEvent {
  final String locationId;

  const ChangePrimaryLocation(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class GetLocationById extends LocationEvent {
  final String locationId;

  const GetLocationById(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class ClearLocationError extends LocationEvent {
  const ClearLocationError();
}

