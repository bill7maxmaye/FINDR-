import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_booking/features/home/presentation/pages/categories_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _subcategories = [];
  List<dynamic> _filteredSubcategories = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSubcategories() async {
    final String response = await rootBundle.loadString(
      'assets/subcategories.json',
    );
    final data = await json.decode(response);
    setState(() {
      _subcategories = data;
      _filteredSubcategories = data;
    });
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSubcategories = _subcategories
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  // Navigation method to CategoriesPage
  void _navigateToCategoriesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoriesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset('assets/images/logo.jpg', height: 28),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Good morning!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ashley Robinson',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/person.jpg'),
                ),
              ],
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
            // Show filtered subcategories
            if (_searchController.text.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: _filteredSubcategories.isEmpty
                    ? const Text('No subcategories found')
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _filteredSubcategories.length,
                        itemBuilder: (context, index) {
                          final sub = _filteredSubcategories[index];
                          return ListTile(
                            title: Text(sub['name']),
                            subtitle: Text(sub['category']),
                            onTap: () {
                              // You can handle subcategory tap here
                            },
                          );
                        },
                      ),
              ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextButton(
                  onPressed: () => _navigateToCategoriesPage(context),
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Square image cards like your screenshot - Now tappable
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1, // square
              children: [
                _CategoryCard(
                  title: 'House Cleaning',
                  image: 'assets/images/houseCleaning.jpg',
                  onTap: () => _navigateToCategoriesPage(context),
                ),
                _CategoryCard(
                  title: 'Help Moving',
                  image: 'assets/images/helpMoving.jpg',
                  onTap: () => _navigateToCategoriesPage(context),
                ),
                _CategoryCard(
                  title: 'Painting',
                  image: 'assets/images/painting.jpg',
                  onTap: () => _navigateToCategoriesPage(context),
                ),
                _CategoryCard(
                  title: 'Electrical Help',
                  image: 'assets/images/electricRepair.jpg',
                  onTap: () => _navigateToCategoriesPage(context),
                ),
              ],
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
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Updated Category Card to be tappable
class _CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.35), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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

