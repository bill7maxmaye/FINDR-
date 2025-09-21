import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/theme.dart';
import 'core/utils/storage_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/location/presentation/bloc/location_event.dart';
import 'features/task_posting/presentation/bloc/task_posting_bloc.dart';
import 'features/task_posting/data/datasources/task_api.dart';
import 'features/task_posting/data/repositories/task_repository_impl.dart';
import 'features/task_posting/domain/usecases/create_task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        BlocProvider<LocationBloc>(create: (_) => LocationBloc()..add(const LoadLocations())),
        BlocProvider<TaskPostingBloc>(
          create: (_) => TaskPostingBloc(
            createTask: CreateTask(TaskRepositoryImpl(api: TaskApiImpl())),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Service Booking',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
