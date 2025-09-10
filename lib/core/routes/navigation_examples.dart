import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Examples of how to use GoRouter navigation in the app
class NavigationExamples {
  
  /// Navigate to login page
  static void goToLogin(BuildContext context) {
    context.go('/login');
  }
  
  /// Navigate to register page
  static void goToRegister(BuildContext context) {
    context.go('/register');
  }
  
  /// Navigate to home page
  static void goToHome(BuildContext context) {
    context.go('/home');
  }
  
  /// Navigate to profile page
  static void goToProfile(BuildContext context) {
    context.go('/profile');
  }
  
  /// Navigate to bookings page
  static void goToBookings(BuildContext context) {
    context.go('/bookings');
  }
  
  /// Navigate to edit profile page
  static void goToEditProfile(BuildContext context) {
    context.go('/edit-profile');
  }
  
  /// Navigate to change password page
  static void goToChangePassword(BuildContext context) {
    context.go('/change-password');
  }
  
  /// Navigate to forgot password page
  static void goToForgotPassword(BuildContext context) {
    context.go('/forgot-password');
  }
  
  /// Navigate to service details page with service ID
  static void goToServiceDetails(BuildContext context, String serviceId) {
    context.go('/service-details?id=$serviceId');
  }
  
  /// Navigate to booking details page with booking ID
  static void goToBookingDetails(BuildContext context, String bookingId) {
    context.go('/booking-details?id=$bookingId');
  }
  
  /// Navigate back to previous page
  static void goBack(BuildContext context) {
    context.pop();
  }
  
  /// Navigate back with result
  static void goBackWithResult(BuildContext context, dynamic result) {
    context.pop(result);
  }
  
  /// Check if can pop (go back)
  static bool canPop(BuildContext context) {
    return context.canPop();
  }
  
  /// Push a new route (adds to navigation stack)
  static void pushRoute(BuildContext context, String route) {
    context.push(route);
  }
  
  /// Push a named route
  static void pushNamed(BuildContext context, String name) {
    context.pushNamed(name);
  }
  
  /// Push with parameters
  static void pushNamedWithParams(BuildContext context, String name, Map<String, String> params) {
    context.pushNamed(name, pathParameters: params);
  }
  
  /// Replace current route
  static void replaceRoute(BuildContext context, String route) {
    context.pushReplacement(route);
  }
  
  /// Replace with named route
  static void replaceNamed(BuildContext context, String name) {
    context.pushReplacementNamed(name);
  }
  
  /// Go to route and clear stack
  static void goAndClearStack(BuildContext context, String route) {
    context.go(route);
  }
  
  /// Show a dialog and navigate based on result
  static Future<void> showDialogAndNavigate(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Navigate?'),
        content: const Text('Do you want to go to the home page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      context.go('/home');
    }
  }
  
  /// Navigate with query parameters
  static void navigateWithQueryParams(BuildContext context, String route, Map<String, String> queryParams) {
    final uri = Uri(path: route, queryParameters: queryParams);
    context.go(uri.toString());
  }
  
  /// Example of conditional navigation based on authentication
  static void navigateBasedOnAuth(BuildContext context, bool isAuthenticated) {
    if (isAuthenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }
}

