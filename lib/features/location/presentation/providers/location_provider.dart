import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../../data/services/location_service.dart';

class LocationProvider extends StatelessWidget {
  final Widget child;

  const LocationProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(
        locationService: LocationService.instance,
      )..add(const LoadLocations()),
      child: child,
    );
  }
}
