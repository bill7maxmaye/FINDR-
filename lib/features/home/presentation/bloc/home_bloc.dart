import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/home_api.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_services.dart';
import '../../../../core/network/api_client.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final GetServices _getServices;
  late final HomeRepository _homeRepository;

  HomeBloc() : super(HomeInitial()) {
    _initializeDependencies();
    on<HomeLoadServices>(_onLoadServices);
    on<HomeLoadCategories>(_onLoadCategories);
    on<HomeSearchServices>(_onSearchServices);
    on<HomeFilterByCategory>(_onFilterByCategory);
    on<HomeClearFilters>(_onClearFilters);
  }

  void _initializeDependencies() {
    final homeApi = HomeApiImpl(ApiClient());
    _homeRepository = HomeRepositoryImpl(homeApi);
    _getServices = GetServices(_homeRepository);
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

