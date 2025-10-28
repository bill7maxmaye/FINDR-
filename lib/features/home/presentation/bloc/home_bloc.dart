import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/home_api.dart';
import '../../data/datasources/categories_api.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_services.dart';
import '../../../../core/network/api_client.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final GetServices _getServices;
  late final HomeRepository _homeRepository;
  late final CategoriesApi _categoriesApi;

  HomeBloc() : super(HomeInitial()) {
    _initializeDependencies();
    on<HomeLoadServices>(_onLoadServices);
    on<HomeLoadCategories>(_onLoadCategories);
    on<HomeLoadCategoriesFromAPI>(_onLoadCategoriesFromAPI);
    on<HomeLoadSubcategories>(_onLoadSubcategories);
    on<HomeSearchServices>(_onSearchServices);
    on<HomeFilterByCategory>(_onFilterByCategory);
    on<HomeClearFilters>(_onClearFilters);
  }

  void _initializeDependencies() {
    final homeApi = HomeApiImpl(ApiClient());
    _homeRepository = HomeRepositoryImpl(homeApi);
    _getServices = GetServices(_homeRepository);
    _categoriesApi = CategoriesApi();
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

  Future<void> _onLoadCategoriesFromAPI(
    HomeLoadCategoriesFromAPI event,
    Emitter<HomeState> emit,
  ) async {
    try {
      print('HomeBloc: Loading categories from API...');
      // Show loading overlay on first load or when we don't have categories yet
      final bool hasCategories = state is HomeLoaded && (state as HomeLoaded).apiCategories.isNotEmpty;
      if (!hasCategories) {
        emit(HomeLoading());
      }
      final response = await _categoriesApi.getAllCategories();
      
      if (response.containsKey('data') && response['data'] is List) {
        final categories = response['data'] as List<dynamic>;
        final apiCategories = categories.map((cat) => cat as Map<String, dynamic>).toList();
        
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          emit(HomeLoaded(
            services: currentState.services,
            categories: currentState.categories,
            apiCategories: apiCategories,
            subcategories: currentState.subcategories,
            selectedCategory: currentState.selectedCategory,
            searchQuery: currentState.searchQuery,
          ));
        } else {
          emit(HomeLoaded(
            services: const [],
            categories: const [],
            apiCategories: apiCategories,
          ));
        }
        print('HomeBloc: Loaded ${apiCategories.length} categories from API');
      }
    } catch (e) {
      print('HomeBloc: Error loading categories from API: $e');
      emit(HomeError(message: 'Failed to load categories: ${e.toString()}'));
    }
  }

  Future<void> _onLoadSubcategories(
    HomeLoadSubcategories event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Clear previous subcategories without putting the whole app into loading
      if (state is HomeLoaded) {
        final s = state as HomeLoaded;
        emit(HomeLoaded(
          services: s.services,
          categories: s.categories,
          apiCategories: s.apiCategories,
          subcategories: const [],
          selectedCategory: s.selectedCategory,
          searchQuery: s.searchQuery,
        ));
      }
      print('HomeBloc: Loading subcategories for category: ${event.categoryId}');
      final response = await _categoriesApi.getSubcategoriesByCategory(event.categoryId);
      
      if (response.containsKey('data') && response['data'] is List) {
        final subcategories = response['data'] as List<dynamic>;
        final mappedSubcategories = subcategories.map((sub) => {
          'name': sub['name'] ?? '',
          'description': sub['description'] ?? '',
          'icon': sub['icon'] ?? '🧹',
          'id': sub['id'] ?? '',
          'mainCategory': event.categoryName,
        }).toList();

        if (state is HomeLoaded) {
          final s = state as HomeLoaded;
          emit(HomeLoaded(
            services: s.services,
            categories: s.categories,
            apiCategories: s.apiCategories,
            subcategories: mappedSubcategories,
            selectedCategory: s.selectedCategory,
            searchQuery: s.searchQuery,
          ));
        }
        print('HomeBloc: Loaded ${mappedSubcategories.length} subcategories from API');
      }
    } catch (e) {
      print('HomeBloc: Error loading subcategories: $e');
      emit(HomeError(message: 'Failed to load subcategories: ${e.toString()}'));
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

