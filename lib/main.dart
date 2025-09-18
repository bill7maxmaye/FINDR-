import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'core/routes/app_router.dart';
import 'core/theme.dart';
import 'core/utils/storage_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/location/presentation/providers/location_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();
  final storageService = StorageService();
  await storageService.initialize();

  runApp(const ServiceBookingApp());
}

class ServiceBookingApp extends StatelessWidget {
  const ServiceBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<BookingBloc>(create: (_) => BookingBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
      ],
      child: LocationProvider(
        child: MaterialApp.router(
          title: 'Service Booking',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
