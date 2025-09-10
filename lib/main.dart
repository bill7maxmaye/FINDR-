import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/routes/app_router.dart';
import 'core/theme.dart';
import 'core/network/dio_client.dart';
import 'core/network/api_client.dart';
import 'core/utils/storage_service.dart';
import 'features/auth/data/datasources/auth_api.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/datasources/home_api.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_services.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/booking/data/datasources/booking_api.dart';
import 'features/booking/data/repositories/booking_repository_impl.dart';
import 'features/booking/domain/repositories/booking_repository.dart';
import 'features/booking/domain/usecases/create_booking.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/profile/data/datasources/profile_api.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/update_profile.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core singletons
  final dioClient = DioClient();

  final storageService = StorageService();
  await storageService.initialize();

  // Auth wiring
  final AuthApi authApi = AuthApiImpl(dioClient);
  final AuthRepository authRepository = AuthRepositoryImpl(authApi, storageService);
  final loginUser = LoginUser(authRepository);
  final registerUser = RegisterUser(authRepository);
  final logoutUser = LogoutUser(authRepository);

  // Home wiring
  final homeApi = HomeApiImpl(ApiClient());
  final HomeRepository homeRepository = HomeRepositoryImpl(homeApi);
  final getServices = GetServices(homeRepository);

  // Booking wiring
  final bookingApi = BookingApiImpl(ApiClient());
  final BookingRepository bookingRepository = BookingRepositoryImpl(bookingApi);
  final createBooking = CreateBooking(bookingRepository);

  // Profile wiring
  final profileApi = ProfileApiImpl(ApiClient());
  final ProfileRepository profileRepository = ProfileRepositoryImpl(profileApi);
  final updateProfile = UpdateProfile(profileRepository);

  runApp(ServiceBookingApp(
    authDependencies: _AuthDependencies(
      loginUser: loginUser,
      registerUser: registerUser,
      logoutUser: logoutUser,
      authRepository: authRepository,
    ),
    homeDependencies: _HomeDependencies(
      getServices: getServices,
      homeRepository: homeRepository,
    ),
    bookingDependencies: _BookingDependencies(
      createBooking: createBooking,
      bookingRepository: bookingRepository,
    ),
    profileDependencies: _ProfileDependencies(
      updateProfile: updateProfile,
      profileRepository: profileRepository,
    ),
  ));
}

class ServiceBookingApp extends StatelessWidget {
  final _AuthDependencies authDependencies;
  final _HomeDependencies homeDependencies;
  final _BookingDependencies bookingDependencies;
  final _ProfileDependencies profileDependencies;

  const ServiceBookingApp({
    super.key,
    required this.authDependencies,
    required this.homeDependencies,
    required this.bookingDependencies,
    required this.profileDependencies,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            loginUser: authDependencies.loginUser,
            registerUser: authDependencies.registerUser,
            logoutUser: authDependencies.logoutUser,
            authRepository: authDependencies.authRepository,
          ),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
            getServices: homeDependencies.getServices,
            homeRepository: homeDependencies.homeRepository,
          ),
        ),
        BlocProvider<BookingBloc>(
          create: (_) => BookingBloc(
            createBooking: bookingDependencies.createBooking,
            bookingRepository: bookingDependencies.bookingRepository,
          ),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            updateProfile: profileDependencies.updateProfile,
            profileRepository: profileDependencies.profileRepository,
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

class _AuthDependencies {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final AuthRepository authRepository;

  _AuthDependencies({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.authRepository,
  });
}

class _HomeDependencies {
  final GetServices getServices;
  final HomeRepository homeRepository;

  _HomeDependencies({
    required this.getServices,
    required this.homeRepository,
  });
}

class _BookingDependencies {
  final CreateBooking createBooking;
  final BookingRepository bookingRepository;

  _BookingDependencies({
    required this.createBooking,
    required this.bookingRepository,
  });
}

class _ProfileDependencies {
  final UpdateProfile updateProfile;
  final ProfileRepository profileRepository;

  _ProfileDependencies({
    required this.updateProfile,
    required this.profileRepository,
  });
}
