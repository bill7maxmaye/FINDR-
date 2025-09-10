import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_services.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetServices _getServices;
  final HomeRepository _homeRepository;

  HomeBloc({
    required GetServices getServices,
    required HomeRepository homeRepository,
  })  : _getServices = getServices,
        _homeRepository = homeRepository,
        super(HomeInitial()) {
    on<HomeLoadServices>(_onLoadServices);
    on<HomeLoadCategories>(_onLoadCategories);
    on<HomeSearchServices>(_onSearchServices);
    on<HomeFilterByCategory>(_onFilterByCategory);
    on<HomeClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadServices(
    HomeLoadServices event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final services = await _getServices.call();
      final categories = await _homeRepository.getCategories();
      emit(HomeLoaded(
        services: services,
        categories: categories,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onLoadCategories(
    HomeLoadCategories event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final categories = await _homeRepository.getCategories();
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(HomeLoaded(
          services: currentState.services,
          categories: categories,
          selectedCategory: currentState.selectedCategory,
          searchQuery: currentState.searchQuery,
        ));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onSearchServices(
    HomeSearchServices event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final services = await _homeRepository.searchServices(event.query);
      final categories = await _homeRepository.getCategories();
      emit(HomeLoaded(
        services: services,
        categories: categories,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onFilterByCategory(
    HomeFilterByCategory event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final services = await _homeRepository.getServicesByCategory(event.category);
      final categories = await _homeRepository.getCategories();
      emit(HomeLoaded(
        services: services,
        categories: categories,
        selectedCategory: event.category,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onClearFilters(
    HomeClearFilters event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final services = await _getServices.call();
      final categories = await _homeRepository.getCategories();
      emit(HomeLoaded(
        services: services,
        categories: categories,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}

