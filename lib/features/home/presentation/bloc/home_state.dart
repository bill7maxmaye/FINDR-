import '../../domain/entities/service.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Service> services;
  final List<String> categories;
  final List<Map<String, dynamic>> apiCategories;
  final List<Map<String, dynamic>> subcategories;
  final String? selectedCategory;
  final String? searchQuery;

  HomeLoaded({
    required this.services,
    required this.categories,
    this.apiCategories = const [],
    this.subcategories = const [],
    this.selectedCategory,
    this.searchQuery,
  });
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}

