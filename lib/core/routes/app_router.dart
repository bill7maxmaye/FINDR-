import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/categories_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/manage_account_page.dart';
import '../../features/booking/presentation/pages/bookings_page.dart';
import '../../features/booking/presentation/pages/my_requests_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/location/presentation/pages/location_page.dart';
import '../../features/location/presentation/pages/add_location_page.dart';
import '../../features/location/presentation/pages/edit_location_page.dart';
import '../../features/task_posting/presentation/pages/task_posting_page.dart';
import '../../features/profile/presentation/pages/provider_profile_detail_page.dart';
import '../../features/profile/presentation/bloc/provider_profile_bloc.dart';
import '../../features/notification/presentation/pages/notifications_page.dart';
import '../../features/notification/presentation/bloc/notification_bloc.dart';
import '../../features/notification/data/datasources/notification_api_impl.dart';
import '../../features/notification/data/repositories/notification_repository_impl.dart';
import '../../features/notification/domain/usecases/get_notifications.dart';
import '../../features/notification/domain/usecases/mark_notification_as_read.dart';
import '../../features/notification/domain/usecases/mark_all_as_read.dart';
import '../theme.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/chat/presentation/bloc/chat_event.dart';

class AppRouter {
  // Development flag - set to true to bypass authentication for testing
  static const bool _isDevelopment = false;
  
  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      // Skip authentication check in development - allow all routes
      if (_isDevelopment) {
        return null;
      }
      
      // Check authentication status
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      
      // If user is authenticated and trying to access auth pages, redirect to home
      if (authState is AuthAuthenticated) {
        if (state.uri.path == '/login' || state.uri.path == '/register') {
          return '/home';
        }
      }
      
      // If user is not authenticated and trying to access protected pages, redirect to login
      if (authState is AuthUnauthenticated || authState is AuthInitial) {
        if (state.uri.path != '/login' && state.uri.path != '/register') {
          return '/login';
        }
      }
      
      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          final categoryId = state.uri.queryParameters['categoryId'];
          final categoryName = state.uri.queryParameters['categoryName'];
          return CategoriesPage(
            mainCategory: category ?? '',
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const BookingsPage(),
      ),
      GoRoute(
        path: '/location',
        name: 'location',
        builder: (context, state) => const LocationPage(),
      ),
      GoRoute(
        path: '/add-location',
        name: 'add-location',
        builder: (context, state) => const AddLocationPage(),
      ),
      GoRoute(
        path: '/edit-location',
        name: 'edit-location',
        builder: (context, state) {
          final location = state.extra as dynamic;
          return EditLocationPage(location: location);
        },
      ),
      GoRoute(
        path: '/post-task',
        name: 'post-task',
        builder: (context, state) {
          final category = state.uri.queryParameters['category'];
          final subcategory = state.uri.queryParameters['subcategory'];
          return TaskPostingPage(
            category: category,
            subcategory: subcategory,
          );
        },
      ),
      GoRoute(
        path: '/provider-profile',
        name: 'provider-profile',
        builder: (context, state) {
          print('Provider profile route called');
          final extra = state.extra as Map<String, dynamic>?;
          final providerId = extra?['providerId'] ?? '1';
          final providerName = extra?['providerName'] ?? 'Provider';
          print('Provider ID: $providerId, Provider name: $providerName');
          return BlocProvider(
            create: (context) => ProviderProfileBloc(),
            child: ProviderProfileDetailPage(
              providerId: providerId,
              providerName: providerName,
            ),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) {
          return BlocProvider(
            create: (context) {
              final notificationApi = NotificationApiImpl();
              final notificationRepository = NotificationRepositoryImpl(notificationApi);
              return NotificationBloc(
                getNotifications: GetNotifications(notificationRepository),
                markAsRead: MarkNotificationAsRead(notificationRepository),
                markAllAsRead: MarkAllAsRead(notificationRepository),
              );
            },
            child: const NotificationsPage(),
          );
        },
      ),
      
      // Additional Routes
      GoRoute(
        path: '/edit-profile',
        name: 'edit-profile',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Edit Profile Page - Coming Soon'),
          ),
        ),
      ),
      GoRoute(
        path: '/change-password',
        name: 'change-password',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Change Password Page - Coming Soon'),
          ),
        ),
      ),
      GoRoute(
        path: '/my-requests',
        name: 'my-requests',
        builder: (context, state) => const MyRequestsPage(),
      ),
      GoRoute(
        path: '/my-reviews',
        name: 'my-reviews',
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: const Text('My Reviews'),
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go('/home');
                }
              },
            ),
          ),
          body: const Center(
            child: Text('My Reviews Page - Coming Soon'),
          ),
        ),
      ),
      GoRoute(
        path: '/manage-account',
        name: 'manage-account',
        builder: (context, state) => const ManageAccountPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => ResetPasswordPage(
          initialToken: state.uri.queryParameters['token'],
        ),
      ),

      GoRoute(
        path: '/verify-email',
        name: 'verify-email',
        builder: (context, state) => EmailVerificationPage(
          email: state.uri.queryParameters['email'],
        ),
      ),
      GoRoute(
        path: '/service-details',
        name: 'service-details',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Service Details Page - Coming Soon'),
          ),
        ),
      ),
      GoRoute(
        path: '/booking-details',
        name: 'booking-details',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Booking Details Page - Coming Soon'),
          ),
        ),
      ),
      
      // Chat routes
      GoRoute(
        path: '/chats',
        name: 'chats',
        builder: (context, state) => const ChatListPage(),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chat',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra = state.extra as Map<String, dynamic>?;
          return BlocProvider(
            create: (_) => ChatBloc()..add(LoadConversation(id, peerName: extra?['peerName'] as String?, avatar: extra?['avatar'] as String?)),
            child: ChatPage(
              chatId: id,
              peerName: extra?['peerName'] as String?,
              avatar: extra?['avatar'] as String?,
            ),
          );
        },
      ),
      
      // Root redirect
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
  
  static GoRouter get router => _router;
}
