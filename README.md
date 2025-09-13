# Service Booking App

A comprehensive Flutter application built with clean architecture, BLoC state management, and feature-first organization.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a **feature-first** approach:

- **Domain Layer**: Business logic, entities, repositories (interfaces), and use cases
- **Data Layer**: API implementations, models, and repository implementations
- **Presentation Layer**: UI components, BLoC state management, and pages
- **Core Layer**: Shared utilities, constants, themes, and network services

## 📁 Project Structure

```
lib/
├── core/                           # Shared utilities and configurations
│   ├── constants.dart             # App-wide constants
│   ├── theme.dart                 # Light and dark themes
│   ├── network/
│   │   └── api_client.dart        # HTTP client wrapper
│   ├── utils/
│   │   ├── validators.dart        # Input validation utilities
│   │   └── storage_service.dart   # Local storage service
│   ├── routes/
│   │   └── app_router.dart        # Centralized routing
│   └── di/
│       └── service_locator.dart   # Dependency injection setup
│
├── features/                      # Feature-based modules
│   ├── auth/                      # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_api.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_user.dart
│   │   │       ├── register_user.dart
│   │   │       └── logout_user.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │       └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/
│   │           ├── auth_text_field.dart
│   │           ├── auth_button.dart
│   │           └── auth_header.dart
│   │
│   ├── home/                      # Home/Services feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── booking/                   # Booking management feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/                   # User profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart                      # App entry point
```

## 🚀 Features

### ✅ Implemented Features

1. **Authentication System**

   - User login with email/password
   - User registration with validation
   - Secure token management
   - Logout functionality

2. **Service Management**

   - Browse available services
   - Service categories filtering
   - Search functionality
   - Service details view

3. **Booking System**

   - Create new bookings
   - View booking history
   - Booking status management
   - Booking cancellation

4. **User Profile**
   - View profile information
   - Update profile details
   - Change password
   - Account management

### 🔧 Technical Features

- **Clean Architecture**: Separation of concerns with clear layer boundaries
- **BLoC State Management**: Reactive state management with events and states
- **API Integration**: RESTful API client with error handling
- **Local Storage**: Secure local data persistence
- **Input Validation**: Comprehensive form validation
- **Responsive Design**: Material Design 3 with light/dark themes
- **Testing**: Unit tests for business logic and BLoC testing

## 🛠️ Dependencies

### Core Dependencies

- `flutter_bloc`: State management
- `go_router`: Declarative routing
- `http`: HTTP client
- `shared_preferences`: Local storage
- `equatable`: Value equality

### Development Dependencies

- `flutter_test`: Testing framework
- `bloc_test`: BLoC testing utilities
- `mockito`: Mocking framework
- `build_runner`: Code generation

## 🚀 Getting Started

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd service_booking
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🧪 Testing

Run tests with:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/domain/usecases/login_user_test.dart

# Run tests with coverage
flutter test --coverage
```

## 📱 Screenshots

The app includes the following main screens:

- **Login Page**: Clean authentication interface
- **Registration Page**: User signup with validation
- **Home Page**: Service browsing with search and filters
- **Bookings Page**: User's booking history
- **Profile Page**: User profile management

## 🔄 State Management

The app uses BLoC pattern for state management:

- **Events**: User actions (login, register, load services, etc.)
- **States**: UI states (loading, success, error, etc.)
- **Bloc**: Business logic that processes events and emits states

## 🧭 Navigation

The app uses GoRouter for declarative routing with authentication guards:

- **Authentication Guards**: Automatic redirects based on auth state
- **Named Routes**: Clean route definitions with names
- **Deep Linking**: Support for URL-based navigation
- **Error Handling**: Custom error pages for invalid routes

### Navigation Examples:

```dart
// Navigate to a page
context.go('/home');

// Navigate with parameters
context.go('/service-details/$serviceId');

// Navigate back
context.pop();
```

## 🌐 API Integration

The app is designed to work with RESTful APIs:

- Base URL configuration in `AppConstants`
- Automatic token management
- Error handling and retry logic
- Request/response logging

## 🎨 Theming

- Material Design 3 implementation
- Light and dark theme support
- Consistent color scheme
- Custom text styles
- Responsive design

## 📝 Code Style

- Consistent naming conventions
- Clear separation of concerns
- Comprehensive error handling
- Extensive documentation
- Type safety with Dart

## 🔮 Future Enhancements

- Push notifications
- Real-time booking updates
- Payment integration
- Advanced search filters
- Offline support
- Multi-language support
- Advanced analytics

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
