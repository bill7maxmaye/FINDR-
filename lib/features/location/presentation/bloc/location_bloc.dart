import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/location_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService _locationService;

  LocationBloc({required LocationService locationService})
      : _locationService = locationService,
        super(const LocationInitial()) {
    on<LoadLocations>(_onLoadLocations);
    on<AddLocation>(_onAddLocation);
    on<UpdateLocation>(_onUpdateLocation);
    on<DeleteLocation>(_onDeleteLocation);
    on<SetPrimaryLocation>(_onSetPrimaryLocation);
    on<ClearError>(_onClearError);
  }

  Future<void> _onLoadLocations(
    LoadLocations event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      final locations = await _locationService.getAllLocations();
      
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
      
      await _locationService.addLocation(
        subCity: event.subCity,
        worada: event.worada,
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
        isPrimary: event.isPrimary,
      );
      
      final locations = await _locationService.getAllLocations();
      emit(LocationSuccess(
        message: 'Location added successfully',
        locations: locations,
      ));
      
      // After a brief moment, emit the loaded state to ensure UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      emit(LocationLoaded(locations: locations));
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
      
      await _locationService.updateLocation(
        id: event.id,
        subCity: event.subCity,
        worada: event.worada,
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
        isPrimary: event.isPrimary,
      );
      
      final locations = await _locationService.getAllLocations();
      emit(LocationSuccess(
        message: 'Location updated successfully',
        locations: locations,
      ));
      
      // After a brief moment, emit the loaded state to ensure UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      emit(LocationLoaded(locations: locations));
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
      
      await _locationService.deleteLocation(event.locationId);
      
      final locations = await _locationService.getAllLocations();
      
      if (locations.isEmpty) {
        emit(const LocationEmpty());
      } else {
        emit(LocationSuccess(
          message: 'Location deleted successfully',
          locations: locations,
        ));
        
        // After a brief moment, emit the loaded state to ensure UI updates
        await Future.delayed(const Duration(milliseconds: 100));
        emit(LocationLoaded(locations: locations));
      }
    } catch (e) {
      emit(LocationError('Failed to delete location: $e'));
    }
  }

  Future<void> _onSetPrimaryLocation(
    SetPrimaryLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      
      await _locationService.setPrimaryLocation(event.locationId);
      
      final locations = await _locationService.getAllLocations();
      emit(LocationSuccess(
        message: 'Primary location updated successfully',
        locations: locations,
      ));
      
      // After a brief moment, emit the loaded state to ensure UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      emit(LocationLoaded(locations: locations));
    } catch (e) {
      emit(LocationError('Failed to set primary location: $e'));
    }
  }

  Future<void> _onClearError(
    ClearError event,
    Emitter<LocationState> emit,
  ) async {
    add(const LoadLocations());
  }
}
