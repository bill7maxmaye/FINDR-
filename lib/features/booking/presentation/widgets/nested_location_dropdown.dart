import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../../../../core/theme.dart';

class NestedLocationDropdown extends StatefulWidget {
  final String? selectedKifleKetema;
  final String? selectedWoreda;
  final Function(String? kifleKetema, String? woreda)? onLocationChanged;
  final String hintText;
  final bool showBothDropdowns;

  const NestedLocationDropdown({
    super.key,
    this.selectedKifleKetema,
    this.selectedWoreda,
    this.onLocationChanged,
    this.hintText = 'Select Location',
    this.showBothDropdowns = false,
  });

  @override
  State<NestedLocationDropdown> createState() => _NestedLocationDropdownState();
}

class _NestedLocationDropdownState extends State<NestedLocationDropdown> {
  Map<String, List<String>> _kifleKetemaData = {};
  String? _selectedKifleKetema;
  String? _selectedWoreda;
  List<String> _availableWoredas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedKifleKetema = widget.selectedKifleKetema;
    _selectedWoreda = widget.selectedWoreda;
    _loadLocationData();
  }

  @override
  void didUpdateWidget(NestedLocationDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKifleKetema != widget.selectedKifleKetema ||
        oldWidget.selectedWoreda != widget.selectedWoreda) {
      _selectedKifleKetema = widget.selectedKifleKetema;
      _selectedWoreda = widget.selectedWoreda;
      if (_selectedKifleKetema != null) {
        _availableWoredas = _kifleKetemaData[_selectedKifleKetema] ?? [];
      }
    }
  }

  Future<void> _loadLocationData() async {
    try {
      final String response = await rootBundle.loadString('assets/locations.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _kifleKetemaData = Map<String, List<String>>.from(
          data['kifle_ketema'].map((key, value) => MapEntry(key, List<String>.from(value)))
        );
        _isLoading = false;
        
        // If we have a selected Kifle Ketema, load its Woredas
        if (_selectedKifleKetema != null) {
          _availableWoredas = _kifleKetemaData[_selectedKifleKetema] ?? [];
        }
      });
    } catch (e) {
      print('Error loading location data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateLocation() {
    if (widget.onLocationChanged != null) {
      widget.onLocationChanged!(_selectedKifleKetema, _selectedWoreda);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
          color: Colors.white,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }

    return Column(
      children: [
        // Kifle Ketema Dropdown
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedKifleKetema,
              hint: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Kifle Ketema',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              isExpanded: true,
              items: _kifleKetemaData.keys.map((String kifleKetema) {
                return DropdownMenuItem<String>(
                  value: kifleKetema,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: AppTheme.primaryColor,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          kifleKetema,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedKifleKetema = newValue;
                  _selectedWoreda = null;
                  _availableWoredas = newValue != null ? _kifleKetemaData[newValue] ?? [] : [];
                });
                _updateLocation();
              },
            ),
          ),
        ),
        
        // Woreda Dropdown (only shows when Kifle Ketema is selected or showBothDropdowns is true)
        if (_selectedKifleKetema != null || widget.showBothDropdowns) ...[
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedWoreda,
                hint: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedKifleKetema != null 
                            ? 'Select Woreda in $_selectedKifleKetema'
                            : 'Select Woreda',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                isExpanded: true,
                items: _availableWoredas.map((String woreda) {
                  return DropdownMenuItem<String>(
                    value: woreda,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppTheme.primaryColor,
                            size: 18,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            woreda,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: _selectedKifleKetema != null ? (String? newValue) {
                  setState(() {
                    _selectedWoreda = newValue;
                  });
                  _updateLocation();
                } : null,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
