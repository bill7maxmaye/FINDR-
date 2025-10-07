import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class AddLocationPage extends StatelessWidget {
  const AddLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _AddLocationPageView();
  }
}

class _AddLocationPageView extends StatefulWidget {
  const _AddLocationPageView();

  @override
  State<_AddLocationPageView> createState() => _AddLocationPageViewState();
}

class _AddLocationPageViewState extends State<_AddLocationPageView> {
  final _formKey = GlobalKey<FormState>();
  final _subCityController = TextEditingController();
  final _woradaController = TextEditingController();
  final _nameController = TextEditingController();
  final _exactLocationController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _latitudeController = TextEditingController();
  bool _isPrimaryLocation = false;

  @override
  void dispose() {
    _subCityController.dispose();
    _woradaController.dispose();
    _nameController.dispose();
    _exactLocationController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }

  void _saveLocation() {
    if (_formKey.currentState!.validate()) {
      context.read<LocationBloc>().add(AddLocationEvent(
        subCity: _subCityController.text,
        worada: _woradaController.text,
        name: _nameController.text,
        longitude: double.parse(_longitudeController.text),
        latitude: double.parse(_latitudeController.text),
        isPrimary: _isPrimaryLocation,
      ));
    }
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
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add Location',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // Return location data to the previous page
            final locationData = {
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'title': _nameController.text,
              'address': '${_subCityController.text}, ${_woradaController.text}',
              'isPrimary': _isPrimaryLocation,
            };
            context.pop(locationData);
          } else if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Location Name Field
                _buildFormField(
                  label: 'Location Name',
                  controller: _nameController,
                  hintText: 'e.g., Home, Office, Warehouse',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Sub City and Worada Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: 'Sub City',
                        controller: _subCityController,
                        hintText: 'Newcastle',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter sub city';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        label: 'Worada',
                        controller: _woradaController,
                        hintText: 'Hamilton',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter worada';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Exact Location Field
                _buildFormField(
                  label: 'Exact Location',
                  controller: _exactLocationController,
                  hintText: '123 King Street',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter exact location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Coordinates Row
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        label: 'Latitude',
                        controller: _latitudeController,
                        hintText: '0.000000',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        label: 'Longitude',
                        controller: _longitudeController,
                        hintText: '0.000000',
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Primary Location Checkbox
                CheckboxListTile(
                  title: const Text('Set as primary location'),
                  subtitle: const Text('This will be your default location'),
                  value: _isPrimaryLocation,
                  onChanged: (value) {
                    setState(() {
                      _isPrimaryLocation = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 30),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is LocationLoading ? null : _saveLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is LocationLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : const Text('Add Location'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondaryColor,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primaryColor),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }
}