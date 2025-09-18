import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';
import '../../domain/entities/location_entity.dart';

class EditLocationPage extends StatelessWidget {
  final LocationEntity location;

  const EditLocationPage({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _EditLocationPageView(location: location);
  }
}

class _EditLocationPageView extends StatefulWidget {
  final LocationEntity location;

  const _EditLocationPageView({required this.location});

  @override
  State<_EditLocationPageView> createState() => _EditLocationPageViewState();
}

class _EditLocationPageViewState extends State<_EditLocationPageView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subCityController;
  late final TextEditingController _woradaController;
  late final TextEditingController _nameController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _latitudeController;
  late bool _isPrimaryLocation;

  @override
  void initState() {
    super.initState();
    _subCityController = TextEditingController(text: widget.location.subCity);
    _woradaController = TextEditingController(text: widget.location.worada);
    _nameController = TextEditingController(text: widget.location.name);
    _longitudeController = TextEditingController(text: widget.location.longitude.toString());
    _latitudeController = TextEditingController(text: widget.location.latitude.toString());
    _isPrimaryLocation = widget.location.isPrimary;
  }

  @override
  void dispose() {
    _subCityController.dispose();
    _woradaController.dispose();
    _nameController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    super.dispose();
  }

  void _updateLocation() {
    if (_formKey.currentState!.validate()) {
      context.read<LocationBloc>().add(UpdateLocationEvent(
        id: widget.location.id,
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
          'Edit Location',
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
            context.pop();
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
                  'Edit Location Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Sub City Field
                TextFormField(
                  controller: _subCityController,
                  decoration: InputDecoration(
                    labelText: 'Sub City',
                    hintText: 'Enter sub city',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter sub city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Worada Field
                TextFormField(
                  controller: _woradaController,
                  decoration: InputDecoration(
                    labelText: 'Worada',
                    hintText: 'Enter worada',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter worada';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Location Name',
                    hintText: 'Enter location name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.place),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Coordinates Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        decoration: InputDecoration(
                          labelText: 'Latitude',
                          hintText: '0.000000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.my_location),
                        ),
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
                      child: TextFormField(
                        controller: _longitudeController,
                        decoration: InputDecoration(
                          labelText: 'Longitude',
                          hintText: '0.000000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.my_location),
                        ),
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
                
                // Update Button
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state is LocationLoading ? null : _updateLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: state is LocationLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Update Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}