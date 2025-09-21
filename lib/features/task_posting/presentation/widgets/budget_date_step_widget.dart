import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class BudgetDateStepWidget extends StatefulWidget {
  final double? budget;
  final DateTime? preferredDate;
  final Function(double?) onBudgetChanged;
  final Function(DateTime?) onPreferredDateChanged;

  const BudgetDateStepWidget({
    super.key,
    required this.budget,
    required this.preferredDate,
    required this.onBudgetChanged,
    required this.onPreferredDateChanged,
  });

  @override
  State<BudgetDateStepWidget> createState() => _BudgetDateStepWidgetState();
}

class _BudgetDateStepWidgetState extends State<BudgetDateStepWidget> {
  final TextEditingController _budgetController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.preferredDate;
    if (widget.budget != null) {
      _budgetController.text = widget.budget!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onPreferredDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Text(
            'Budget & Date',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your budget and preferred date for the service (both optional)',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),
        
          // Budget Section
          Text(
            'Budget (Optional)',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final budget = double.tryParse(value);
              widget.onBudgetChanged(budget);
            },
            decoration: InputDecoration(
              hintText: 'Enter your budget amount',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: const Icon(
                Icons.attach_money,
                color: AppTheme.primaryColor,
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Leave empty to let providers suggest their rates',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        
          const SizedBox(height: 32),
          
          // Preferred Date Section
          Text(
            'Preferred Date (Optional)',
            style: AppTextStyles.heading3.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.borderColor),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select a date',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _selectedDate != null
                          ? AppTheme.textPrimaryColor
                          : AppTheme.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  if (_selectedDate != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = null;
                        });
                        widget.onPreferredDateChanged(null);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.errorColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Leave empty to let providers suggest available dates',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
