import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc({required LocationRepository locationRepository})
      : _locationRepository = locationRepository,
        super(const LocationInitial()) {
    on<LoadAllLocations>(_onLoadAllLocations);
    on<AddLocation>(_onAddLocation);
    on<UpdateLocation>(_onUpdateLocation);
    on<DeleteLocation>(_onDeleteLocation);
    on<ChangePrimaryLocation>(_onChangePrimaryLocation);
    on<GetLocationById>(_onGetLocationById);
    on<ClearLocationError>(_onClearLocationError);
  }

  Future<void> _onLoadAllLocations(
    LoadAllLocations event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      final locations = await _locationRepository.getAllLocations();
      
      if (locations.isEmpty) {
        emit(const LocationEmpty());
      } else {
        emit(LocationLoaded(locations: locations));
      }
    } catch (e) {
      emit(LocationError('Failed to load locations: $e'));
    }
  }

  Future<void> _onAddLocation(
    AddLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      await _locationRepository.addLocation(
        subCity: event.subCity,
        worada: event.worada,
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
        isPrimary: event.isPrimary,
      );
      final locations = await _locationRepository.getAllLocations();
      
      emit(LocationOperationSuccess(
        message: 'Location added successfully',
        locations: locations,
      ));
    } catch (e) {
      emit(LocationError('Failed to add location: $e'));
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      await _locationRepository.updateLocation(
        id: event.id,
        subCity: event.subCity,
        worada: event.worada,
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
        isPrimary: event.isPrimary,
      );
      final locations = await _locationRepository.getAllLocations();
      
      emit(LocationOperationSuccess(
        message: 'Location updated successfully',
        locations: locations,
      ));
    } catch (e) {
      emit(LocationError('Failed to update location: $e'));
    }
  }

  Future<void> _onDeleteLocation(
    DeleteLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      await _locationRepository.deleteLocation(event.locationId);
      final locations = await _locationRepository.getAllLocations();
      
      if (locations.isEmpty) {
        emit(const LocationEmpty());
      } else {
        emit(LocationOperationSuccess(
          message: 'Location deleted successfully',
          locations: locations,
        ));
      }
    } catch (e) {
      emit(LocationError('Failed to delete location: $e'));
    }
  }

  Future<void> _onChangePrimaryLocation(
    ChangePrimaryLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      await _locationRepository.changePrimaryLocation(event.locationId);
      final locations = await _locationRepository.getAllLocations();
      
      emit(LocationOperationSuccess(
        message: 'Primary location changed successfully',
        locations: locations,
      ));
    } catch (e) {
      emit(LocationError('Failed to change primary location: $e'));
    }
  }

  Future<void> _onGetLocationById(
    GetLocationById event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      final location = await _locationRepository.getLocationById(event.locationId);
      
      if (location != null) {
        emit(LocationDetailLoaded(location));
      } else {
        emit(const LocationError('Location not found'));
      }
    } catch (e) {
      emit(LocationError('Failed to get location: $e'));
    }
  }

  Future<void> _onClearLocationError(
    ClearLocationError event,
    Emitter<LocationState> emit,
  ) async {
    // Reload locations to get back to normal state
    add(const LoadAllLocations());
  }
}