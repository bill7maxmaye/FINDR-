import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/location_api.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_all_locations.dart';
import '../../domain/usecases/add_location.dart';
import '../../domain/usecases/update_location.dart';
import '../../domain/usecases/delete_location.dart';
import '../../domain/usecases/get_location_by_id.dart';
import '../../domain/usecases/change_primary_location.dart';
import '../../../../core/network/dio_client.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  late final GetAllLocations _getAllLocations;
  late final AddLocation _addLocation;
  late final UpdateLocation _updateLocation;
  late final DeleteLocation _deleteLocation;
  late final ChangePrimaryLocation _changePrimaryLocation;
  late final LocationRepository _locationRepository;

  LocationBloc() : super(const LocationInitial()) {
    _initializeDependencies();
    on<LoadLocations>(_onLoadLocations);
    on<AddLocationEvent>(_onAddLocation);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<DeleteLocationEvent>(_onDeleteLocation);
    on<SetPrimaryLocation>(_onSetPrimaryLocation);
    on<ClearError>(_onClearError);
  }

  void _initializeDependencies() {
    final dioClient = DioClient();
    final locationApi = LocationApiImpl(dioClient);
    _locationRepository = LocationRepositoryImpl(locationApi);
    _getAllLocations = GetAllLocations(_locationRepository);
    _addLocation = AddLocation(_locationRepository);
    _updateLocation = UpdateLocation(_locationRepository);
    _deleteLocation = DeleteLocation(_locationRepository);
    _changePrimaryLocation = ChangePrimaryLocation(_locationRepository);
  }

  Future<void> _onLoadLocations(
    LoadLocations event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      final locations = await _getAllLocations.call();
      
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
    AddLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      
      await _addLocation.call(AddLocationParams(
        subCity: event.subCity,
        worada: event.worada,
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
        isPrimary: event.isPrimary,
      ));
      
      final locations = await _getAllLocations.call();
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
    UpdateLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      
      await _updateLocation.call(UpdateLocationParams(
        id: event.id,
        subCity: event.subCity,
        worada: event.worada,
        name: event.name,
        longitude: event.longitude,
        latitude: event.latitude,
        isPrimary: event.isPrimary,
      ));
      
      final locations = await _getAllLocations.call();
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
    DeleteLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      emit(const LocationLoading());
      
      await _deleteLocation.call(event.locationId);
      
      final locations = await _getAllLocations.call();
      
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
      
      await _changePrimaryLocation.call(event.locationId);
      
      final locations = await _getAllLocations.call();
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