import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class DateTimePickerModal extends StatefulWidget {
  final String providerName;
  final String providerInitials;
  final Function(DateTime selectedDate, String selectedTime) onConfirm;

  const DateTimePickerModal({
    Key? key,
    required this.providerName,
    required this.providerInitials,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<DateTimePickerModal> createState() => _DateTimePickerModalState();
}

class _DateTimePickerModalState extends State<DateTimePickerModal> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  String _selectedTime = '';

  final List<String> _timeSlots = [
    '9:00am', '12:00pm', '3:00pm', '6:00pm', '8:00pm', '10:00pm'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isMobile ? MediaQuery.of(context).size.width * 0.95 : MediaQuery.of(context).size.width * 0.9,
        height: isMobile ? MediaQuery.of(context).size.height * 0.85 : MediaQuery.of(context).size.height * 0.7,
        child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Setup Time',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose your task date and start time:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Provider info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          widget.providerInitials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Provider',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.providerName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCalendarSection(),
          ),
          
          const SizedBox(height: 20),
          
          // Time Picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildTimePicker(),
          ),
          
          const SizedBox(height: 20),
          
          // Request Summary
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getFormattedDateTime(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedDate != null && _selectedTime.isNotEmpty
                        ? () {
                            print('Send Request button pressed!');
                            print('Selected date: $_selectedDate');
                            print('Selected time: $_selectedTime');
                            // Close the date picker modal first
                            Navigator.of(context).pop();
                            // Then call the callback after a short delay
                            Future.delayed(const Duration(milliseconds: 100), () {
                              widget.onConfirm(_selectedDate!, _selectedTime);
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedDate != null && _selectedTime.isNotEmpty 
                          ? AppTheme.primaryColor 
                          : Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _selectedDate != null && _selectedTime.isNotEmpty 
                          ? 'Send Request' 
                          : 'Select Date & Time',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Panel - Date and Time Selection
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Setup Time',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Choose your task date and start time:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Provider Availability
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          widget.providerInitials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected Provider',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.providerName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Calendar Section
                _buildCalendarSection(),
                const SizedBox(height: 24),

                // Time Picker
                _buildTimePicker(),
                const SizedBox(height: 24),

                // Instructional Text
                Text(
                  'You can chat to adjust task details or change start time after confirming.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Panel - Request Summary
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Request for:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _getFormattedDateTime(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedDate != null && _selectedTime.isNotEmpty
                        ? () {
                            // Close the date picker modal first
                            Navigator.of(context).pop();
                            // Then call the callback after a short delay
                            Future.delayed(const Duration(milliseconds: 100), () {
                              widget.onConfirm(_selectedDate!, _selectedTime);
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Send Request',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getMonthYear(_currentMonth),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left, color: Colors.grey),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Column(
      children: [
        // Days of week header
        Row(
          children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),

        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - firstDayWeekday + 1;
              final isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;
              final dayDate = isCurrentMonth
                  ? DateTime(_currentMonth.year, _currentMonth.month, dayNumber)
                  : null;

              final isSelected = _selectedDate != null &&
                  dayDate != null &&
                  _selectedDate!.year == dayDate.year &&
                  _selectedDate!.month == dayDate.month &&
                  _selectedDate!.day == dayDate.day;

              final isToday = dayDate != null &&
                  dayDate.year == DateTime.now().year &&
                  dayDate.month == DateTime.now().month &&
                  dayDate.day == DateTime.now().day;

              return Expanded(
                child: GestureDetector(
                  onTap: isCurrentMonth ? () => _selectDate(dayDate!) : null,
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : isToday
                              ? AppTheme.primaryColor.withOpacity(0.2)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: AppTheme.primaryColor, width: 1)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        isCurrentMonth ? dayNumber.toString() : '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? AppTheme.primaryColor
                                  : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTime.isEmpty ? null : _selectedTime,
              hint: const Text(
                'Choose a time slot',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: _timeSlots.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                print('Time selected: $newValue');
                setState(() {
                  _selectedTime = newValue ?? '';
                });
                print('Updated _selectedTime: $_selectedTime');
              },
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getFormattedDateTime() {
    if (_selectedDate == null || _selectedTime.isEmpty) {
      return 'Select date and time';
    }
    
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[_selectedDate!.month - 1]} ${_selectedDate!.day}, ${_selectedTime}';
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    print('Date selected: $date');
    setState(() {
      _selectedDate = date;
    });
    print('Updated _selectedDate: $_selectedDate');
  }
}