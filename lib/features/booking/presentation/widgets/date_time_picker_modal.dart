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
  DateTime? _selectedDate;
  String _selectedTime = '1:30pm';
  late DateTime _currentMonth;

  final List<String> _timeSlots = [
    '8:00am', '8:30am', '9:00am', '9:30am', '10:00am', '10:30am',
    '11:00am', '11:30am', '12:00pm', '12:30pm', '1:00pm', '1:30pm',
    '2:00pm', '2:30pm', '3:00pm', '3:30pm', '4:00pm', '4:30pm',
    '5:00pm', '5:30pm', '6:00pm', '6:30pm', '7:00pm', '7:30pm',
    '8:00pm', '8:30pm', '9:00pm', '9:30pm', '10:00pm'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Row(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Provider Availability
                    Row(
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
                        Text(
                          '${widget.providerName}\'s Availability',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
                        onPressed: _selectedDate != null ? _sendRequest : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                    const SizedBox(height: 12),
                    Text(
                      'Next, confirm your details to get connected with your Tasker.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Calendar Grid
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
                    ),
                    child: Center(
                      child: Text(
                        isCurrentMonth ? dayNumber.toString() : '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          'Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTime,
              isExpanded: true,
              items: _timeSlots.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTime = newValue;
                  });
                }
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
    if (_selectedDate == null) return 'Select a date';
    
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final month = months[_selectedDate!.month - 1];
    final day = _selectedDate!.day;
    
    return 'Sep $day, $_selectedTime';
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
    setState(() {
      _selectedDate = date;
    });
  }

  void _sendRequest() {
    if (_selectedDate != null) {
      widget.onConfirm(_selectedDate!, _selectedTime);
      Navigator.of(context).pop();
    }
  }
}
