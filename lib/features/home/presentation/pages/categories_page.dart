import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/shimmer_loading.dart';

class CategoriesPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String mainCategory;
  const CategoriesPage({
    Key? key, 
    required this.mainCategory,
    this.categoryId,
    this.categoryName,
  }) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredCategories = [];
  List<Map<String, dynamic>> _allSubcategories = [];

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadSubcategories() async {
    // Load subcategories from API using BLoC
    if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
      print('Loading subcategories for category: ${widget.categoryId}');
      context.read<HomeBloc>().add(HomeLoadSubcategories(
        categoryId: widget.categoryId!,
        categoryName: widget.categoryName ?? widget.mainCategory,
      ));
      return;
    }

    // No fallback to local JSON - use API only
    print('No categoryId provided - using API data only');
    setState(() {
      _allSubcategories = [];
      _filteredCategories = [];
    });
  }


  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Show grid view with current category's subcategories
        // This will be handled by BlocBuilder
      } else {
        // Show search results from API subcategories only
        final apiSubcategories = _getApiSubcategoriesForSearch();
        _filteredCategories = apiSubcategories
            .where((cat) => cat['name'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  List<Map<String, dynamic>> _getApiSubcategoriesForSearch() {
    // Get all API subcategories from all categories for comprehensive search
    final homeBloc = context.read<HomeBloc>();
    if (homeBloc.state is HomeLoaded) {
      final state = homeBloc.state as HomeLoaded;
      final List<Map<String, dynamic>> allApiSubcategories = [];
      
      // Add current category's subcategories
      if (state.subcategories.isNotEmpty) {
        allApiSubcategories.addAll(state.subcategories);
      }
      
      // Add subcategories from all categories
      if (state.apiCategories.isNotEmpty) {
        for (final category in state.apiCategories) {
          if (category['subCategories'] != null && category['subCategories'] is List) {
            final subCategories = category['subCategories'] as List<dynamic>;
            for (final sub in subCategories) {
              allApiSubcategories.add({
                'name': sub['name'] ?? '',
                'description': sub['description'] ?? '',
                'icon': sub['icon'] ?? '🧹',
                'id': sub['id'] ?? '',
                'mainCategory': category['name'] ?? '',
                'categoryId': category['id'] ?? '',
              });
            }
          }
        }
      }
      
      return allApiSubcategories;
    }
    
    return [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.categoryName ?? (widget.mainCategory.isEmpty ? 'Categories' : widget.mainCategory),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      cursorColor: AppTheme.primaryColor,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search subcategories...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _filteredCategories.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Show loading, search results, or grid based on state
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          // Global overlay already shows spinner; avoid duplicate
                          return const SizedBox.shrink();
                        } else if (state is HomeLoaded) {
                          // If a specific category is selected, ensure we only render its subcategories
                          if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
                            // Determine if current state's subcategories belong to this page's category
                            final hasCurrentCategoryData = state.subcategories.isNotEmpty &&
                                (state.subcategories.first['mainCategory'] ==
                                    (widget.categoryName ?? widget.mainCategory));

                            if (!hasCurrentCategoryData) {
                              // Global overlay already shows spinner; avoid duplicate
                              return const SizedBox.shrink();
                            }

                            return _buildCategoriesGridFromBloc(state.subcategories);
                          }

                          // Otherwise, aggregate all subcategories from all categories (See All flow)
                          final List<Map<String, dynamic>> allApiSubcategories = [];
                          if (state.apiCategories.isNotEmpty) {
                            for (final category in state.apiCategories) {
                              if (category['subCategories'] != null && category['subCategories'] is List) {
                                final subCategories = category['subCategories'] as List<dynamic>;
                                for (final sub in subCategories) {
                                  allApiSubcategories.add({
                                    'name': sub['name'] ?? '',
                                    'description': sub['description'] ?? '',
                                    'icon': sub['icon'] ?? '🧹',
                                    'id': sub['id'] ?? '',
                                    'mainCategory': category['name'] ?? '',
                                    'categoryId': category['id'] ?? '',
                                  });
                                }
                              }
                            }
                          }

                          if (allApiSubcategories.isNotEmpty) {
                            return _buildCategoriesGridFromBloc(allApiSubcategories);
                          }

                          // Fallback empty state
                          return _buildCategoriesGrid();
                        } else {
                          return _buildCategoriesGrid();
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
        // Full-screen loading overlay with blur to include AppBar
        BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final bool needsGlobalOverlay = state is HomeLoading ||
                (state is HomeLoaded && widget.categoryId != null && widget.categoryId!.isNotEmpty &&
                  (state.subcategories.isEmpty || state.subcategories.first['mainCategory'] != (widget.categoryName ?? widget.mainCategory)));
            if (!needsGlobalOverlay) return const SizedBox.shrink();
            return Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                          child: const ColoredBox(color: Color(0x0A000000)),
                        ),
                      ),
                    ),
                    const Center(child: UltraBeautifulLoadingIndicator()),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }


  Widget _buildSearchResults() {
    return _filteredCategories.isEmpty
        ? _buildEmptySearchState()
        : Column(
            children: [
              // Search results header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${_filteredCategories.length} result${_filteredCategories.length == 1 ? '' : 's'} found',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Search results list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final sub = _filteredCategories[index];
                    return _buildSearchResultItem(sub);
                  },
                ),
              ),
            ],
          );
  }

  Widget _buildEmptySearchState() {
    // Check if we have API data available
    final homeBloc = context.read<HomeBloc>();
    final hasApiData = homeBloc.state is HomeLoaded && 
                      (homeBloc.state as HomeLoaded).apiCategories.isNotEmpty;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasApiData ? Icons.search_off : Icons.cloud_off,
              size: 40,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasApiData ? 'No subcategories found' : 'No API data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasApiData 
              ? 'Try searching with different keywords'
              : 'Please wait for categories to load',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Center(
            child: sub['icon'] is String 
              ? Text(
                  sub['icon'],
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                )
              : Icon(
                  sub['icon'] as IconData, 
                  size: 24, 
                  color: AppTheme.primaryColor,
                ),
          ),
        ),
        title: Text(
          sub['name'],
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          sub['mainCategory'] ?? 'Category',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.primaryColor,
          ),
        ),
        onTap: () {
          // Navigate to task posting page with selected subcategory
          final category = sub['mainCategory'] ?? 'General';
          final subcategory = sub['name'];
          context.go('/post-task?category=${Uri.encodeComponent(category)}&subcategory=${Uri.encodeComponent(subcategory)}');
        },
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final cat = _filteredCategories[index];
        return _CategoryItem(
          icon: cat['icon'],
          label: cat['name'],
          onTap: () {
            // Navigate to task posting page with selected subcategory
            final category = cat['mainCategory'];
            final subcategory = cat['name'];
            context.go('/post-task?category=${Uri.encodeComponent(category)}&subcategory=${Uri.encodeComponent(subcategory)}');
          },
        );
      },
    );
  }

  Widget _buildCategoriesGridFromBloc(List<Map<String, dynamic>> subcategories) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final cat = subcategories[index];
        return _CategoryItem(
          icon: cat['icon'],
          label: cat['name'],
          onTap: () {
            // Navigate to task posting page with selected subcategory
            final category = cat['mainCategory'];
            final subcategory = cat['name'];
            context.go('/post-task?category=${Uri.encodeComponent(category)}&subcategory=${Uri.encodeComponent(subcategory)}');
          },
        );
      },
    );
  }
}

// Subcategory Preview Skeleton for loading state
class _SubcategoryPreviewSkeleton extends StatelessWidget {
  const _SubcategoryPreviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 8, // Show 8 skeleton items
      itemBuilder: (context, index) => _buildSkeletonItem(),
    );
  }

  Widget _buildSkeletonItem() {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 50,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final dynamic icon; // Can be IconData or String (emoji)
  final String label;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: icon is String 
                ? Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  )
                : Icon(icon as IconData, size: 24, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 70),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
