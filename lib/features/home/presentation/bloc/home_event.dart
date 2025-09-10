abstract class HomeEvent {}

class HomeLoadServices extends HomeEvent {}

class HomeLoadCategories extends HomeEvent {}

class HomeSearchServices extends HomeEvent {
  final String query;

  HomeSearchServices({required this.query});
}

class HomeFilterByCategory extends HomeEvent {
  final String category;

  HomeFilterByCategory({required this.category});
}

class HomeClearFilters extends HomeEvent {}

