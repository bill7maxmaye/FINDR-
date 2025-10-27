import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../../../profile/presentation/widgets/profile_dropdown.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load only from API, not local JSON
    context.read<HomeBloc>().add(HomeLoadCategoriesFromAPI());
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Get all subcategories from API for search
  List<Map<String, dynamic>> _getAllSubcategoriesFromAPI() {
    final homeBloc = context.read<HomeBloc>();
    if (homeBloc.state is HomeLoaded) {
      final state = homeBloc.state as HomeLoaded;
      final List<Map<String, dynamic>> allSubcategories = [];
      
      // Get subcategories from all categories
      if (state.apiCategories.isNotEmpty) {
        for (final category in state.apiCategories) {
          if (category['subCategories'] != null && category['subCategories'] is List) {
            final subCategories = category['subCategories'] as List<dynamic>;
            for (final sub in subCategories) {
              allSubcategories.add({
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
      
      return allSubcategories;
    }
    
    return [];
  }

  // Filter subcategories based on search query
  List<Map<String, dynamic>> _getFilteredSubcategories() {
    if (_searchQuery.isEmpty) {
      return [];
    }
    
    final allSubcategories = _getAllSubcategoriesFromAPI();
    return allSubcategories
        .where((sub) => sub['name'].toLowerCase().contains(_searchQuery))
        .toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //use theme data
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/logo.jpg'),
            radius: 28,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on_outlined),
            onPressed: () {
              context.go('/location');
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              context.go('/notifications');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String userName = 'User';
                String userEmail = 'user@example.com';
                String profileImageUrl = 'assets/images/person.jpg';
                
                if (state is AuthAuthenticated) {
                  userName = state.user.fullName;
                  userEmail = state.user.email;
                  // Use user's image if available, otherwise default
                  profileImageUrl = (state.user.profileImageUrl != null && state.user.profileImageUrl!.isNotEmpty)
                      ? state.user.profileImageUrl!
                      : 'assets/images/person.jpg';
                }
                
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good morning!',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProfileDropdown(
                      userName: userName,
                      userEmail: userEmail,
                      profileImageUrl: profileImageUrl,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),

            // Working Search Field - Fixed blue border issue
            // Search Field with filtering
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      cursorColor: Colors.grey,
                      decoration: const InputDecoration(
                        hintText: 'What do you need help with?',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Show search results from API
            if (_searchQuery.isNotEmpty) _buildSearchResults(),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                  TextButton(
                    onPressed: () => context.push('/categories'),
                    child: Text(
                      'See All',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Square image cards using BLoC state
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoaded && state.apiCategories.isNotEmpty) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1, // square
                    children: state.apiCategories.take(4).map((category) {
                      return _CategoryCard(
                        title: category['name'] ?? 'Category',
                        icon: category['icon'] ?? '🧹',
                        description: category['description'] ?? '',
                        onTap: () => context.push('/categories?categoryId=${category['id']}&categoryName=${Uri.encodeComponent(category['name'])}'),
                      );
                    }).toList(),
                  );
                } else if (state is HomeLoading) {
                  return const UltraBeautifulLoadingIndicator(
                    message: 'Loading categories...',
                    subtitle: 'Fetching the latest services',
                    previewWidget: _CategoryPreviewSkeleton(),
                  );
                } else {
                  return const UltraBeautifulLoadingIndicator(
                    message: 'Loading categories...',
                    subtitle: 'Fetching the latest services',
                    previewWidget: _CategoryPreviewSkeleton(),
                  );
                }
              },
            ),
            const SizedBox(height: 44),

            const Text(
              'Find a tasker at extremely preferential prices',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),

            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/electricRepair.jpg',
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Find Now'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 44),

            const Text(
              'Top Tasker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 12),

            // Updated Tasker Cards with better layout
            SizedBox(
              height: 200, // Slightly increased height for better spacing
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _TaskerCard(
                    name: 'Dave Ginbegnaw',
                    job: 'Mounting',
                    image: 'assets/images/person.jpg',
                    rating: 4.8,
                    reviews: 252,
                  ),
                  SizedBox(width: 12),
                  _TaskerCard(
                    name: 'Bemni Kelemkebi',
                    job: 'House Cleaning',
                    image: 'assets/images/person.jpg',
                    rating: 4.9,
                    reviews: 142,
                  ),
                  SizedBox(width: 12),
                  _TaskerCard(
                    name: 'Papu Anatiw',
                    job: 'Anatiw',
                    image: 'assets/images/person.jpg',
                    rating: 4.7,
                    reviews: 98,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: AppTheme.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final filteredResults = _getFilteredSubcategories();
    
    if (filteredResults.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'No subcategories found',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Try searching with different keywords',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredResults.length,
            itemBuilder: (context, index) {
              final sub = filteredResults[index];
              return _buildSearchResultItem(sub);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: sub['icon'] is String 
              ? Text(
                  sub['icon'] as String,
                  style: const TextStyle(fontSize: 20),
                )
              : Icon(
                  Icons.category,
                  size: 20,
                  color: AppTheme.primaryColor,
                ),
          ),
        ),
        title: Text(
          sub['name'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          sub['mainCategory'] ?? 'Category',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () {
          // Navigate to task posting page with API data
          final category = sub['mainCategory'] ?? 'General';
          final subcategory = sub['name'] ?? '';
          context.go('/post-task?category=${Uri.encodeComponent(category)}&subcategory=${Uri.encodeComponent(subcategory)}');
        },
      ),
    );
  }
}

// Category Preview Skeleton for loading state
class _CategoryPreviewSkeleton extends StatelessWidget {
  const _CategoryPreviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSkeletonCard(),
        const SizedBox(width: 12),
        _buildSkeletonCard(),
      ],
    );
  }

  Widget _buildSkeletonCard() {
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
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
              width: 40,
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

// Updated Category Card to be tappable
class _CategoryCard extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -20,
              right: -20,
              child: Opacity(
                opacity: 0.1,
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- REDESIGNED Tasker Card ----------
class _TaskerCard extends StatelessWidget {
  final String name;
  final String job;
  final String image;
  final double rating;
  final int reviews;
  const _TaskerCard({
    required this.name,
    required this.job,
    required this.image,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Fixed width for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image with better aspect ratio
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content area with better padding
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with better constraints
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 4),

                // Job title
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    job,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // Rating and reviews in a compact layout
                Row(
                  children: [
                    // Star icon
                    const Icon(Icons.star, color: Colors.amber, size: 16),

                    const SizedBox(width: 4),

                    // Rating value
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 4),

                    // Reviews count
                    Expanded(
                      child: Text(
                        '($reviews)',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
