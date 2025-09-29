import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../widgets/provider_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../../../profile/presentation/widgets/date_time_picker_modal.dart';
import '../../../profile/presentation/widgets/task_scheduled_success_dialog.dart';

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
  int _activeFilterCount = 0;
  List<String> _selectedProviders = [];
  List<String> _selectedRatings = [];
  double _minPrice = 10.0;
  double _maxPrice = 50.0;
  double _maxDistance = 30.0;
  bool _availableOnly = true;
  String? _selectedKifleKetema;
  String? _selectedWoreda;
  DateTime? _selectedDate;
  List<String> _selectedTimeSlots = [];

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

  @override
  void initState() {
    super.initState();
    // Add test filters to see the chips
    _selectedKifleKetema = 'Bole';
    _selectedWoreda = 'Bole Sub City';
    _selectedDate = DateTime.now();
    _selectedTimeSlots = ['morning'];
    _minPrice = 20.0;
    _maxPrice = 100.0;
    _selectedRatings = ['4', '5'];
    _activeFilterCount = _calculateActiveFilters();
  }

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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
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
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Filters
          _buildActiveFilters(),

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
    // Show date/time picker modal
    showDialog(
      context: context,
      builder: (context) => DateTimePickerModal(
        providerName: provider['name'] ?? 'Provider',
        providerInitials: _getInitials(provider['name'] ?? 'Provider'),
        onConfirm: (selectedDate, selectedTime) {
          _showSuccessDialog(provider, selectedDate, selectedTime);
        },
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'P';
  }

  void _showSuccessDialog(Map<String, dynamic> provider, DateTime selectedDate, String selectedTime) {
    print('_showSuccessDialog called!');
    print('Provider: ${provider['name']}');
    print('Selected date: $selectedDate');
    print('Selected time: $selectedTime');
    
    final taskTitle = 'Task with ${provider['name']}';
    final scheduledDate = _formatDate(selectedDate);
    
    print('Task title: $taskTitle');
    print('Scheduled date: $scheduledDate');
    
    try {
      print('About to call TaskScheduledSuccessDialog.show');
      TaskScheduledSuccessDialog.show(
        context: context,
        taskTitle: taskTitle,
        scheduledDate: scheduledDate,
        scheduledTime: selectedTime,
        providerName: provider['name'] ?? 'Provider',
        onViewRequest: () {
          print('View request clicked');
          // Navigate to bookings page or request details
          context.go('/bookings');
        },
        onClose: () {
          print('Close clicked');
          // Navigate back to home or provider selection
          context.go('/home');
        },
      );
      print('TaskScheduledSuccessDialog.show completed successfully');
    } catch (e) {
      print('Error calling TaskScheduledSuccessDialog.show: $e');
    }
  }

  String _formatDate(DateTime date) {
    print('_formatDate called with: $date');
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final result = '${months[date.month - 1]} ${date.day}';
    print('_formatDate result: $result');
    return result;
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

  Widget _buildActiveFilters() {
    List<Widget> filterChips = [];
    
    // Location filter
    if (_selectedKifleKetema != null && _selectedWoreda != null) {
      filterChips.add(_buildFilterChip(
        '${_selectedKifleKetema}, ${_selectedWoreda}',
        Icons.location_on,
        () => _removeLocationFilter(),
      ));
    }
    
    // Price range filter
    if (_minPrice > 10.0 || _maxPrice < 50.0) {
      filterChips.add(_buildFilterChip(
        '${_minPrice.toInt()}-${_maxPrice.toInt()} Birr',
        Icons.attach_money,
        () => _removePriceFilter(),
      ));
    }
    
    // Rating filter
    if (_selectedRatings.isNotEmpty) {
      filterChips.add(_buildFilterChip(
        '${_selectedRatings.join(', ')} Stars',
        Icons.star,
        () => _removeRatingFilter(),
      ));
    }
    
    // Date filter
    if (_selectedDate != null) {
      final dateStr = '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      filterChips.add(_buildFilterChip(
        dateStr,
        Icons.calendar_today,
        () => _removeDateFilter(),
      ));
    }
    
    // Time slots filter
    if (_selectedTimeSlots.isNotEmpty) {
      filterChips.add(_buildFilterChip(
        _selectedTimeSlots.join(', '),
        Icons.access_time,
        () => _removeTimeSlotsFilter(),
      ));
    }
    
    if (filterChips.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...filterChips,
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterChip(String label, IconData icon, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          onRemove();
        },
        child: Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: AppTheme.primaryColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.close,
                size: 16,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          side: BorderSide(color: AppTheme.primaryColor.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
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
        selectedKifleKetema: _selectedKifleKetema,
        selectedWoreda: _selectedWoreda,
        selectedDate: _selectedDate,
        selectedTimeSlots: _selectedTimeSlots,
        onApplyFilters: (filters) {
          setState(() {
            _selectedProviders = filters['providers'] ?? [];
            _selectedRatings = filters['ratings'] ?? [];
            _minPrice = filters['minPrice'] ?? 10.0;
            _maxPrice = filters['maxPrice'] ?? 50.0;
            _maxDistance = filters['maxDistance'] ?? 30.0;
            _availableOnly = filters['availableOnly'] ?? true;
            _selectedKifleKetema = filters['kifleKetema'];
            _selectedWoreda = filters['woreda'];
            _selectedDate = filters['date'];
            _selectedTimeSlots = List<String>.from(filters['timeSlots'] ?? []);
            _activeFilterCount = _calculateActiveFilters();
          });
        },
      ),
    );
  }

  void _removeLocationFilter() {
    setState(() {
      _selectedKifleKetema = null;
      _selectedWoreda = null;
      _activeFilterCount = _calculateActiveFilters();
    });
  }
  
  void _removePriceFilter() {
    setState(() {
      _minPrice = 10.0;
      _maxPrice = 50.0;
      _activeFilterCount = _calculateActiveFilters();
    });
  }
  
  void _removeRatingFilter() {
    setState(() {
      _selectedRatings = [];
      _activeFilterCount = _calculateActiveFilters();
    });
  }
  
  void _removeDateFilter() {
    setState(() {
      _selectedDate = null;
      _activeFilterCount = _calculateActiveFilters();
    });
  }
  
  void _removeTimeSlotsFilter() {
    setState(() {
      _selectedTimeSlots = [];
      _activeFilterCount = _calculateActiveFilters();
    });
  }

  int _calculateActiveFilters() {
    int count = 0;
    if (_selectedKifleKetema != null && _selectedWoreda != null) count++;
    if (_selectedProviders.isNotEmpty) count++;
    if (_selectedRatings.isNotEmpty) count++;
    if (_minPrice > 10.0 || _maxPrice < 50.0) count++;
    if (_maxDistance < 30.0) count++;
    if (_selectedDate != null) count++;
    if (_selectedTimeSlots.isNotEmpty) count++;
    if (!_availableOnly) count++;
    return count;
  }
}
