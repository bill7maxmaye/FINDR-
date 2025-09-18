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

  const LocationLoaded({required this.locations});

  @override
  List<Object?> get props => [locations];
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

class LocationSuccess extends LocationState {
  final String message;
  final List<LocationEntity> locations;

  const LocationSuccess({
    required this.message,
    required this.locations,
  });

  @override
  List<Object?> get props => [message, locations];
}
