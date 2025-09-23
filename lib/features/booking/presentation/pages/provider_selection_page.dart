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
      'name': 'Karmel A.',
      'rating': 4.9,
      'reviewCount': 358,
      'taskCount': 811,
      'price': 129,
      'distance': 2.5,
      'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'description': 'Why Choose me? • Price include TWO TASKERS 👥👥 of my team (Labor only) • never last minute cancellation • Last-minute availability • 2h minimum • your belongings are moved safely with caution! satisfaction guaranteed!! Let\'s Make Your Move a Smooth One! Book us today and see why...',
    },
    {
      'id': '2',
      'name': 'Victoria Popa',
      'rating': 4.7,
      'reviewCount': 245,
      'taskCount': 105,
      'price': 95,
      'distance': 1.2,
      'profileImage': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      'description': 'Professional cleaning services with eco-friendly products. I provide deep cleaning, regular maintenance, and specialized services. Your satisfaction is guaranteed!',
    },
    {
      'id': '3',
      'name': 'Stella Milevski',
      'rating': 4.8,
      'reviewCount': 189,
      'taskCount': 141,
      'price': 110,
      'distance': 3.1,
      'description': 'Experienced cleaner with attention to detail. I offer comprehensive cleaning solutions for homes and offices. Flexible scheduling and competitive rates.',
    },
    {
      'id': '4',
      'name': 'Kurt Bates',
      'rating': 4.6,
      'reviewCount': 156,
      'taskCount': 142,
      'price': 85,
      'distance': 4.2,
      'profileImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'description': 'Reliable and professional service provider. Specialized in maintenance and repair work. Quick response time and quality workmanship guaranteed.',
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
                  onSelectProvider: () {
                    // Handle provider selection
                    _selectProvider(provider);
                  },
                  onViewProfile: () {
                    // Handle view profile
                    _viewProviderProfile(provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _selectProvider(Map<String, dynamic> provider) {
    // Handle provider selection - navigate to booking confirmation or next step
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${provider['name']}'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
    // TODO: Navigate to booking confirmation page
  }

  void _viewProviderProfile(Map<String, dynamic> provider) {
    // Navigate to provider profile page
    print('Navigating to provider profile: ${provider['id']}');
    print('Provider name: ${provider['name']}');
    try {
      context.push(
        '/provider-profile',
        extra: {
          'providerId': provider['id'],
          'providerName': provider['name'],
        },
      );
    } catch (e) {
      print('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
