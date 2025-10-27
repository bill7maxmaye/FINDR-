abstract class HomeEvent {}

class HomeLoadServices extends HomeEvent {}

class HomeLoadCategories extends HomeEvent {}

class HomeLoadCategoriesFromAPI extends HomeEvent {}

class HomeLoadSubcategories extends HomeEvent {
  final String categoryId;
  final String categoryName;

  HomeLoadSubcategories({required this.categoryId, required this.categoryName});
}

class HomeSearchServices extends HomeEvent {
  final String query;

  HomeSearchServices({required this.query});
}

class HomeFilterByCategory extends HomeEvent {
  final String category;

  HomeFilterByCategory({required this.category});
}

class HomeClearFilters extends HomeEvent {}

