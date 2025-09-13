import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSubCategories();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadSubCategories() async {
    final String data = await rootBundle.loadString(
      'assets/subcategories.json',
    );
    final Map<String, dynamic> jsonResult = json.decode(data);
    final List subCats = jsonResult[widget.mainCategory] ?? [];
    setState(() {
      _subCategories = subCats
          .map<Map<String, dynamic>>(
            (item) => {
              'name': item['name'],
              'icon': _iconFromString(item['icon']),
            },
          )
          .toList();
      _filteredCategories = List.from(_subCategories);
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
      default:
        return Icons.category;
    }
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _subCategories
          .where((cat) => cat['name'].toLowerCase().contains(query))
          .toList();
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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.mainCategory,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.black),
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
            // Categories Grid - Fixed overflow by reducing childAspectRatio
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12, // Reduced spacing
                  mainAxisSpacing: 12, // Reduced spacing
                  childAspectRatio:
                      0.75, // Reduced from 0.85 to prevent overflow
                ),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final cat = _filteredCategories[index];
                  return _CategoryItem(
                    icon: cat['icon'],
                    label: cat['name'],
                    onTap: () {
                      // Handle subcategory tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
        padding: const EdgeInsets.all(4), // Reduced padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40, // Reduced size
              height: 40, // Reduced size
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Colors.black87,
              ), // Reduced icon size
            ),
            const SizedBox(height: 6), // Reduced spacing
            // Constrained text widget to prevent overflow
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 70, // Slightly reduced for better fitting
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11, // Slightly reduced font size
                  fontWeight: FontWeight.w500,
                  height: 1.1, // Reduced line height
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
