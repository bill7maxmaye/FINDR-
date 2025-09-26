import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../../core/theme.dart';
import 'nested_location_dropdown.dart';

class FilterBottomSheet extends StatefulWidget {
  final int activeFilterCount;
  final List<String> selectedProviders;
  final List<String> selectedRatings;
  final double minPrice;
  final double maxPrice;
  final double maxDistance;
  final bool availableOnly;
  final String? selectedKifleKetema;
  final String? selectedWoreda;
  final DateTime? selectedDate;
  final List<String> selectedTimeSlots;
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
    this.selectedKifleKetema,
    this.selectedWoreda,
    this.selectedDate,
    this.selectedTimeSlots = const [],
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
  late String? _selectedKifleKetema;
  late String? _selectedWoreda;
  late DateTime? _selectedDate;
  late List<String> _selectedTimeSlots;

  final List<Map<String, dynamic>> _providers = [
    {'id': '1', 'name': 'Templeton Peck', 'served': 105, 'experience': 8, 'selected': true},
    {'id': '2', 'name': 'Stella Milevski', 'served': 141, 'experience': 7, 'selected': true},
    {'id': '3', 'name': 'Kurt Bates', 'served': 142, 'experience': 5.5, 'selected': false},
    {'id': '4', 'name': 'Rhonda Rhodes', 'served': 30, 'experience': 5, 'selected': false},
    {'id': '5', 'name': 'Ricky Smith', 'served': 50, 'experience': 4.5, 'selected': false},
  ];

  // Location data
  List<String> _availableWoredas = [];
  Map<String, List<String>> _kifleKetemaData = {};

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
    _selectedKifleKetema = widget.selectedKifleKetema;
    _selectedWoreda = widget.selectedWoreda;
    _selectedDate = widget.selectedDate;
    _selectedTimeSlots = List.from(widget.selectedTimeSlots);
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    try {
      final String response = await rootBundle.loadString('assets/locations.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _kifleKetemaData = Map<String, List<String>>.from(
          data['kifle_ketema'].map((key, value) => MapEntry(key, List<String>.from(value)))
        );
      });
    } catch (e) {
      print('Error loading location data: $e');
    }
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
                Tab(text: 'Location'),
                Tab(text: 'Price & rating'),
                Tab(text: 'Date & Time'),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLocationTab(),
                _buildPriceRatingTab(),
                _buildDateTimeTab(),
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

  Widget _buildLocationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location Section
          Text(
            'Service Location',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Nested Location Dropdown
          NestedLocationDropdown(
            selectedKifleKetema: _selectedKifleKetema,
            selectedWoreda: _selectedWoreda,
            onLocationChanged: (kifleKetema, woreda) {
              setState(() {
                _selectedKifleKetema = kifleKetema;
                _selectedWoreda = woreda;
              });
            },
          ),
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

  Widget _buildDateTimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Section
          Text(
            'Date',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Date Selection Buttons
          Row(
            children: [
              Expanded(
                child: _buildDateButton('Today', _selectedDate != null),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateButton('Choose Dates', _selectedDate == null),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Time of day Section
          Text(
            'Time of day',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          // Time Slot Checkboxes
          _buildTimeSlotCheckbox('Morning (8am - 12pm)', 'morning'),
          _buildTimeSlotCheckbox('Afternoon (12pm - 5pm)', 'afternoon'),
          _buildTimeSlotCheckbox('Evening (5pm - 9:30pm)', 'evening'),
          
          const SizedBox(height: 24),
          
          // Specific Time Option
          Text(
            'or choose a specific time',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          
          // Specific Time Dropdown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Specific Time',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.textSecondaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (text == 'Today') {
            _selectedDate = DateTime.now();
          } else {
            _selectedDate = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSlotCheckbox(String label, String value) {
    final isSelected = _selectedTimeSlots.contains(value);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  _selectedTimeSlots.add(value);
                } else {
                  _selectedTimeSlots.remove(value);
                }
              });
            },
            activeColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
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
      'kifleKetema': _selectedKifleKetema,
      'woreda': _selectedWoreda,
      'date': _selectedDate,
      'timeSlots': _selectedTimeSlots,
    };
    
    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }
}
