import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatefulWidget {
  final String mainCategory;
  const CategoriesPage({Key? key, required this.mainCategory})
    : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _subCategories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  List<Map<String, dynamic>> _allSubcategories = [];

  @override
  void initState() {
    super.initState();
    _loadAllSubcategories();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadAllSubcategories() async {
    final String data = await rootBundle.loadString(
      'assets/subcategories.json',
    );
    final Map<String, dynamic> jsonResult = json.decode(data);

    // Load all subcategories from all main categories for search
    final List<Map<String, dynamic>> allSubs = [];
    jsonResult.forEach((mainCat, subs) {
      for (var sub in subs) {
        allSubs.add({
          'name': sub['name'],
          'mainCategory': mainCat,
          'icon': _iconFromString(sub['icon']),
        });
      }
    });

    setState(() {
      _allSubcategories = allSubs;
      
      // If mainCategory is empty, show all subcategories
      if (widget.mainCategory.isEmpty) {
        _subCategories = allSubs;
        _filteredCategories = List.from(allSubs);
      } else {
        // Load specific subcategories for the current main category
        final List subCats = jsonResult[widget.mainCategory] ?? [];
        _subCategories = subCats
            .map<Map<String, dynamic>>(
              (item) => {
                'name': item['name'],
                'mainCategory': widget.mainCategory,
                'icon': _iconFromString(item['icon']),
              },
            )
            .toList();
        _filteredCategories = List.from(_subCategories);
      }
    });
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'handyman':
        return Icons.handyman;
      case 'format_paint':
        return Icons.format_paint;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'restaurant':
        return Icons.restaurant;
      case 'plumbing':
        return Icons.plumbing;
      case 'content_cut':
        return Icons.content_cut;
      default:
        return Icons.category;
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        // Show grid view with current category's subcategories
        _filteredCategories = List.from(_subCategories);
      } else {
        // Show search results from ALL subcategories
        _filteredCategories = _allSubcategories
            .where((cat) => cat['name'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.mainCategory.isEmpty ? 'Categories' : widget.mainCategory,
          // style: const TextStyle(
          //   color: Colors.black,
          //   fontWeight: FontWeight.bold,
          // ),
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
            // Search Bar
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
                        hintText: 'Search here',
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
            const SizedBox(height: 20),

            // Show search results or grid based on search state
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildCategoriesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return _filteredCategories.isEmpty
        ? const Center(child: Text('No subcategories found'))
        : ListView.builder(
            itemCount: _filteredCategories.length,
            itemBuilder: (context, index) {
              final sub = _filteredCategories[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(sub['icon'], size: 24, color: Colors.black87),
                ),
                title: Text(sub['name']),
                subtitle: Text(sub['mainCategory']),
                onTap: () {
                  // Navigate to task posting page with selected subcategory
                  final category = sub['mainCategory'];
                  final subcategory = sub['name'];
                  context.go('/post-task?category=${Uri.encodeComponent(category)}&subcategory=${Uri.encodeComponent(subcategory)}');
                },
              );
            },
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
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
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
              child: Icon(icon, size: 24, color: Colors.black87),
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
