import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final int activeFilterCount;
  final List<String> selectedProviders;
  final List<String> selectedRatings;
  final double minPrice;
  final double maxPrice;
  final double maxDistance;
  final bool availableOnly;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheet({
    super.key,
    required this.activeFilterCount,
    required this.selectedProviders,
    required this.selectedRatings,
    required this.minPrice,
    required this.maxPrice,
    required this.maxDistance,
    required this.availableOnly,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _selectedProviders;
  late List<String> _selectedRatings;
  late double _minPrice;
  late double _maxPrice;
  late double _maxDistance;
  late bool _availableOnly;

  final List<Map<String, dynamic>> _providers = [
    {'id': '1', 'name': 'Templeton Peck', 'served': 105, 'experience': 8, 'selected': true},
    {'id': '2', 'name': 'Stella Milevski', 'served': 141, 'experience': 7, 'selected': true},
    {'id': '3', 'name': 'Kurt Bates', 'served': 142, 'experience': 5.5, 'selected': false},
    {'id': '4', 'name': 'Rhonda Rhodes', 'served': 30, 'experience': 5, 'selected': false},
    {'id': '5', 'name': 'Ricky Smith', 'served': 50, 'experience': 4.5, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedProviders = List.from(widget.selectedProviders);
    _selectedRatings = List.from(widget.selectedRatings);
    _minPrice = widget.minPrice;
    _maxPrice = widget.maxPrice;
    _maxDistance = widget.maxDistance;
    _availableOnly = widget.availableOnly;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    'Filter by (${widget.activeFilterCount})',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppTheme.textPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the close button
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.borderColor),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondaryColor,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Provider'),
                Tab(text: 'Price & rating'),
                Tab(text: 'Distance'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProviderTab(),
                _buildPriceRatingTab(),
                _buildDistanceTab(),
              ],
            ),
          ),
          
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearAllFilters,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Clear all'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available Provider Only Toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  'AVAILABLE PROVIDER ONLY',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Switch(
                value: _availableOnly,
                onChanged: (value) {
                  setState(() {
                    _availableOnly = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Provider List Header
          Text(
            'Provider list (${_providers.length})',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.textSecondaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Experience Dropdown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 8),
                Text(
                  'Highest experience',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Provider List
          ..._providers.map((provider) => _buildProviderItem(provider)).toList(),
        ],
      ),
    );
  }

  Widget _buildProviderItem(Map<String, dynamic> provider) {
    final isSelected = provider['selected'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                provider['selected'] = value;
                if (value == true) {
                  _selectedProviders.add(provider['id']);
                } else {
                  _selectedProviders.remove(provider['id']);
                }
              });
            },
            activeColor: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundImage: const AssetImage('assets/images/person.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider['name'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${provider['served']} served • ${provider['experience']} years of experience',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRatingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price Range
          Text(
            'Price range',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Price Slider
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 10,
            max: 100,
            divisions: 18,
            activeColor: AppTheme.primaryColor,
            onChanged: (values) {
              setState(() {
                _minPrice = values.start;
                _maxPrice = values.end;
              });
            },
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${_minPrice.toInt()}'),
              Text('\$${_maxPrice.toInt()}'),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Ratings
          Text(
            'Ratings',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(5, (index) {
            final rating = 5 - index;
            final isSelected = _selectedRatings.contains(rating.toString());
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedRatings.add(rating.toString());
                        } else {
                          _selectedRatings.remove(rating.toString());
                        }
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < rating ? Icons.star : Icons.star_border,
                        size: 20,
                        color: starIndex < rating ? Colors.amber : AppTheme.borderColor,
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$rating rate',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDistanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Near by location toggle
          Row(
            children: [
              Expanded(
                child: Text(
                  'Near by location',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              Switch(
                value: false, // This would be controlled by state
                onChanged: (value) {
                  // Handle toggle
                },
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Distance
          Text(
            'Distance location',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Distance Slider
          Slider(
            value: _maxDistance,
            min: 10,
            max: 60,
            divisions: 10,
            activeColor: AppTheme.primaryColor,
            onChanged: (value) {
              setState(() {
                _maxDistance = value;
              });
            },
          ),
          
          // Distance markers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [10, 20, 30, 40, 50, 60].map((distance) {
              return Column(
                children: [
                  Container(
                    width: 2,
                    height: 8,
                    color: _maxDistance >= distance ? AppTheme.primaryColor : AppTheme.borderColor,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${distance}km',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _maxDistance >= distance ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedProviders.clear();
      _selectedRatings.clear();
      _minPrice = 10.0;
      _maxPrice = 50.0;
      _maxDistance = 30.0;
      _availableOnly = true;
      
      // Reset provider selection
      for (var provider in _providers) {
        provider['selected'] = false;
      }
    });
  }

  void _applyFilters() {
    final filters = {
      'providers': _selectedProviders,
      'ratings': _selectedRatings,
      'minPrice': _minPrice,
      'maxPrice': _maxPrice,
      'maxDistance': _maxDistance,
      'availableOnly': _availableOnly,
    };
    
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }
}
