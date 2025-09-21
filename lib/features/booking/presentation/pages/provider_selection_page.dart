import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../widgets/provider_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/subcategory_tabs.dart';

class ProviderSelectionPage extends StatefulWidget {
  final String category;
  final String subcategory;
  final String location;
  final String title;
  final String summary;
  final List<String> images;
  final double? budget;
  final DateTime? preferredDate;

  const ProviderSelectionPage({
    super.key,
    required this.category,
    required this.subcategory,
    required this.location,
    required this.title,
    required this.summary,
    required this.images,
    this.budget,
    this.preferredDate,
  });

  @override
  State<ProviderSelectionPage> createState() => _ProviderSelectionPageState();
}

class _ProviderSelectionPageState extends State<ProviderSelectionPage> {
  String _searchQuery = '';
  int _activeFilterCount = 0;
  List<String> _selectedProviders = [];
  List<String> _selectedRatings = [];
  double _minPrice = 10.0;
  double _maxPrice = 50.0;
  double _maxDistance = 30.0;
  bool _availableOnly = true;

  final List<Map<String, dynamic>> _providers = [
    {
      'id': '1',
      'name': 'Victoria Popa',
      'rating': 3.0,
      'distance': 10.0,
      'served': 105,
      'experience': 8,
      'services': [
        {
          'name': 'Ac deep cleaning',
          'price': 12.0,
          'duration': '30mins',
          'minServicemen': 2,
          'description': 'Foamjet technology removes dust 2x deeper.',
          'image': 'assets/images/ac_cleaning_1.jpg',
          'isAdded': true,
        }
      ],
    },
    {
      'id': '2',
      'name': 'Stella Milevski',
      'rating': 3.0,
      'distance': 10.0,
      'served': 141,
      'experience': 7,
      'services': [
        {
          'name': 'Anti-rust deep clean',
          'price': 12.0,
          'duration': '30mins',
          'minServicemen': 1,
          'description': 'Foamjet technology removes dust 2x deeper.',
          'image': 'assets/images/ac_cleaning_2.jpg',
          'isAdded': false,
        }
      ],
    },
    {
      'id': '3',
      'name': 'Kurt Bates',
      'rating': 3.0,
      'distance': 10.0,
      'served': 142,
      'experience': 5.5,
      'services': [
        {
          'name': 'AC Maintenance',
          'price': 15.0,
          'duration': '45mins',
          'minServicemen': 1,
          'description': 'Complete AC maintenance and cleaning.',
          'image': 'assets/images/ac_cleaning_3.jpg',
          'isAdded': false,
          'discount': 10,
        }
      ],
    },
  ];

  final List<String> _subcategories = [
    'Ac Repair',
    'Installation',
    'Hanging',
    'Servicing',
    'Paint',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.iconColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If there's nothing to pop, go to home page
              context.go('/home');
            }
          },
        ),
        title: Text(
          widget.subcategory,
          style: const TextStyle(
            color: AppTheme.iconColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppTheme.iconColor),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: AppTheme.iconColor),
                onPressed: () => _showFilterBottomSheet(),
              ),
              if (_activeFilterCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_activeFilterCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/person.jpg'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Subcategory Tabs
          SubcategoryTabs(
            subcategories: _subcategories,
            selectedIndex: 0,
            onTabChanged: (index) {
              // Handle subcategory change
            },
          ),

          // Provider List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _providers.length,
              itemBuilder: (context, index) {
                final provider = _providers[index];
                return ProviderCard(
                  provider: provider,
                  onServiceAdded: (serviceId) {
                    setState(() {
                      // Update service added state
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        activeFilterCount: _activeFilterCount,
        selectedProviders: _selectedProviders,
        selectedRatings: _selectedRatings,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        maxDistance: _maxDistance,
        availableOnly: _availableOnly,
        onApplyFilters: (filters) {
          setState(() {
            _selectedProviders = filters['providers'] ?? [];
            _selectedRatings = filters['ratings'] ?? [];
            _minPrice = filters['minPrice'] ?? 10.0;
            _maxPrice = filters['maxPrice'] ?? 50.0;
            _maxDistance = filters['maxDistance'] ?? 30.0;
            _availableOnly = filters['availableOnly'] ?? true;
            _activeFilterCount = _calculateActiveFilters();
          });
        },
      ),
    );
  }

  int _calculateActiveFilters() {
    int count = 0;
    if (_selectedProviders.isNotEmpty) count++;
    if (_selectedRatings.isNotEmpty) count++;
    if (_minPrice > 10.0 || _maxPrice < 50.0) count++;
    if (_maxDistance < 30.0) count++;
    if (!_availableOnly) count++;
    return count;
  }
}
