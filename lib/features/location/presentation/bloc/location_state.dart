import 'package:equatable/equatable.dart';
import '../../domain/entities/location_entity.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final List<LocationEntity> locations;

  const LocationLoaded({
    required this.locations,
  });

  @override
  List<Object?> get props => [locations];

  LocationLoaded copyWith({
    List<LocationEntity>? locations,
  }) {
    return LocationLoaded(
      locations: locations ?? this.locations,
    );
  }
}

class LocationEmpty extends LocationState {
  const LocationEmpty();
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationOperationSuccess extends LocationState {
  final String message;
  final List<LocationEntity> locations;

  const LocationOperationSuccess({
    required this.message,
    required this.locations,
  });

  @override
  List<Object?> get props => [message, locations];
}

class LocationDetailLoaded extends LocationState {
  final LocationEntity location;

  const LocationDetailLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

