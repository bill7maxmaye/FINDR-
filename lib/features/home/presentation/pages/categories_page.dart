import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _categoriesData = [
    {'name': 'Ac Repair', 'icon': Icons.ac_unit},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Carpenter', 'icon': Icons.handyman},
    {'name': 'Cooking', 'icon': Icons.restaurant},
    {'name': 'Electrician', 'icon': Icons.electrical_services},
    {'name': 'Painter', 'icon': Icons.format_paint},
    {'name': 'Plumber', 'icon': Icons.plumbing},
    {'name': 'Salon', 'icon': Icons.content_cut},
    {'name': 'Ac Repair', 'icon': Icons.ac_unit},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Carpenter', 'icon': Icons.handyman},
    {'name': 'Cooking', 'icon': Icons.restaurant},
    {'name': 'Electrician', 'icon': Icons.electrical_services},
    {'name': 'Painter', 'icon': Icons.format_paint},
    {'name': 'Plumber', 'icon': Icons.plumbing},
    {'name': 'Salon', 'icon': Icons.content_cut},
    {'name': 'Ac Repair', 'icon': Icons.ac_unit},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
  ];
  late List<Map<String, dynamic>> _filteredCategories;

  @override
  void initState() {
    super.initState();
    _filteredCategories = List.from(_categoriesData);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _categoriesData
          .where((cat) => cat['name'].toLowerCase().contains(query))
          .toList();
    });
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
        title: const Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
            // Categories Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: _filteredCategories.length,
                itemBuilder: (context, index) {
                  final cat = _filteredCategories[index];
                  return _CategoryItem(
                    icon: cat['icon'],
                    label: cat['name'],
                    onTap: () {
                      // Handle category tap
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
