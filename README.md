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
│   ├── constants.dart             # App-wide constants (API URLs, timeouts, validation rules)
│   ├── theme.dart                 # Material Design 3 themes (light/dark mode)
│   ├── network/
│   │   ├── api_client.dart        # HTTP client wrapper for REST API calls
│   │   └── dio_client.dart        # Dio HTTP client with interceptors and error handling
│   ├── routes/
│   │   ├── app_router.dart        # GoRouter configuration with route guards
│   │   └── navigation_examples.dart # Navigation usage examples
│   ├── services/                  # Core services (empty - for future services)
│   └── utils/
│       ├── validators.dart        # Form validation utilities (email, password, etc.)
│       └── storage_service.dart   # Local storage service (SharedPreferences wrapper)
│
├── features/                      # Feature-based modules (Clean Architecture)
│   ├── auth/                      # 🔐 Authentication & User Management
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_api.dart  # API calls for login, register, password reset
│   │   │   ├── models/
│   │   │   │   └── user_model.dart # User data model with JSON serialization
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart      # User business entity
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       ├── login_user.dart # Login business logic
│   │   │       ├── register_user.dart # Registration business logic
│   │   │       └── logout_user.dart # Logout business logic
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart # Authentication state management
│   │       │   ├── auth_event.dart # Authentication events
│   │       │   └── auth_state.dart # Authentication states
│   │       ├── pages/
│   │       │   ├── login_page.dart # Login screen UI
│   │       │   ├── register_page.dart # Registration screen UI
│   │       │   ├── forgot_password_page.dart # Password reset request UI
│   │       │   ├── reset_password_page.dart # Password reset form UI
│   │       │   └── verify_email_page.dart # Email verification UI
│   │       └── widgets/
│   │           ├── auth_text_field.dart # Custom text input widget
│   │           ├── auth_button.dart # Custom button widget
│   │           └── auth_header.dart # Authentication header widget
│   │
│   ├── home/                      # 🏠 Home & Service Discovery
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── home_api.dart  # API calls for services and categories
│   │   │   ├── models/
│   │   │   │   └── service_model.dart # Service data model
│   │   │   └── repositories/
│   │   │       └── home_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── service.dart   # Service business entity
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       └── get_services.dart # Get services business logic
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── home_bloc.dart # Home state management
│   │       │   ├── home_event.dart # Home events
│   │       │   └── home_state.dart # Home states
│   │       ├── pages/
│   │       │   ├── home_page.dart # Main home screen with service grid
│   │       │   └── categories_page.dart # Service categories page
│   │       └── widgets/
│   │           ├── service_card.dart # Service display card
│   │           ├── category_chip.dart # Category selection chip
│   │           └── search_bar.dart # Service search widget
│   │
│   ├── booking/                   # 📅 Booking & Provider Management
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── booking_api.dart # API calls for bookings and providers
│   │   │   ├── models/
│   │   │   │   └── booking_model.dart # Booking data model
│   │   │   └── repositories/
│   │   │       └── booking_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── booking.dart   # Booking business entity
│   │   │   ├── repositories/
│   │   │   │   └── booking_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       └── create_booking.dart # Create booking business logic
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── booking_bloc.dart # Booking state management
│   │       │   ├── booking_event.dart # Booking events
│   │       │   └── booking_state.dart # Booking states
│   │       ├── pages/
│   │       │   ├── bookings_page.dart # User's booking history
│   │       │   └── provider_selection_page.dart # Provider selection with filters
│   │       └── widgets/
│   │           ├── booking_card.dart # Booking display card
│   │           ├── provider_card.dart # Provider display card
│   │           ├── filter_bottom_sheet.dart # Filter options bottom sheet
│   │           ├── nested_location_dropdown.dart # Location selection widget
│   │           ├── search_bar_widget.dart # Search functionality
│   │           └── subcategory_tabs.dart # Service subcategory tabs
│   │
│   ├── location/                  # 📍 Location Management
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── location_api.dart # API calls for location CRUD operations
│   │   │   ├── models/
│   │   │   │   ├── location_model.dart # Location data model
│   │   │   │   └── location_model.g.dart # Generated JSON serialization
│   │   │   └── repositories/
│   │   │       └── location_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── location_entity.dart # Location business entity
│   │   │   ├── repositories/
│   │   │   │   └── location_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       ├── add_location.dart # Add location business logic
│   │   │       ├── update_location.dart # Update location business logic
│   │   │       ├── delete_location.dart # Delete location business logic
│   │   │       ├── get_all_locations.dart # Get all locations business logic
│   │   │       ├── get_location_by_id.dart # Get specific location business logic
│   │   │       └── change_primary_location.dart # Set primary location business logic
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── location_bloc.dart # Location state management
│   │       │   ├── location_event.dart # Location events
│   │       │   └── location_state.dart # Location states
│   │       └── pages/
│   │           ├── location_page.dart # Location management page
│   │           ├── add_location_page.dart # Add new location page
│   │           └── edit_location_page.dart # Edit existing location page
│   │
│   ├── notification/              # 🔔 Notification System
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── notification_api.dart # Notification API interface
│   │   │   │   └── notification_api_impl.dart # Mock notification implementation
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart # Notification data model
│   │   │   └── repositories/
│   │   │       └── notification_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification.dart # Notification business entity
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       ├── get_notifications.dart # Get notifications business logic
│   │   │       ├── mark_notification_as_read.dart # Mark single notification as read
│   │   │       └── mark_all_as_read.dart # Mark all notifications as read
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── notification_bloc.dart # Notification state management
│   │       │   ├── notification_event.dart # Notification events
│   │       │   └── notification_state.dart # Notification states
│   │       ├── pages/
│   │       │   └── notifications_page.dart # Notifications list page
│   │       └── widgets/
│   │           ├── notification_card.dart # Individual notification card
│   │           ├── notification_filter_chip.dart # Notification filter chip
│   │           └── notification_empty_state.dart # Empty state widget
│   │
│   ├── profile/                   # 👤 User Profile & Provider Details
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_api.dart # Profile API calls
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── repositories/
│   │   │   │   └── profile_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       └── get_profile.dart # Get profile business logic
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── profile_bloc.dart # Profile state management
│   │       │   ├── profile_event.dart # Profile events
│   │       │   ├── profile_state.dart # Profile states
│   │       │   ├── provider_profile_bloc.dart # Provider profile state management
│   │       │   ├── provider_profile_event.dart # Provider profile events
│   │       │   └── provider_profile_state.dart # Provider profile states
│   │       ├── pages/
│   │       │   ├── profile_page.dart # User profile page
│   │       │   └── provider_profile_detail_page.dart # Provider detail page
│   │       └── widgets/
│   │           ├── profile_header.dart # Profile header widget
│   │           ├── skeleton_loading.dart # Loading skeleton widgets
│   │           └── profile_stats_card.dart # Profile statistics card
│   │
│   ├── task_posting/              # 📝 Task Creation & Management
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── task_api.dart # Task API calls (currently mock implementation)
│   │   │   ├── models/
│   │   │   │   └── task_model.dart # Task data model
│   │   │   └── repositories/
│   │   │       └── task_repository_impl.dart # Repository implementation
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── task.dart # Task business entity
│   │   │   ├── repositories/
│   │   │   │   └── task_repository.dart # Repository interface
│   │   │   └── usecases/
│   │   │       └── create_task.dart # Create task business logic
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── task_posting_bloc.dart # Task posting state management
│   │       │   ├── task_posting_event.dart # Task posting events
│   │       │   └── task_posting_state.dart # Task posting states
│   │       ├── pages/
│   │       │   ├── task_posting_page.dart # Main task posting page
│   │       │   └── task_posting_page_new.dart # Alternative task posting page
│   │       └── widgets/
│   │           ├── location_details_step_widget.dart # Location selection step
│   │           ├── service_selection_step_widget.dart # Service selection step
│   │           ├── task_details_step_widget.dart # Task details step
│   │           ├── budget_step_widget.dart # Budget selection step
│   │           ├── schedule_step_widget.dart # Schedule selection step
│   │           ├── contact_info_step_widget.dart # Contact information step
│   │           └── review_step_widget.dart # Review and submit step
│   │
└── main.dart                      # App entry point and initialization
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

## 🌐 API Integration & Backend Endpoints

The app is designed to work with RESTful APIs. Here are the required API endpoints for each feature:

### 🔐 Authentication Endpoints

**Base URL**: `https://api.servicebooking.com/v1`

| Endpoint                   | Method | Purpose                | Request Body                                              | Response                      |
| -------------------------- | ------ | ---------------------- | --------------------------------------------------------- | ----------------------------- |
| `/sign-in/email`           | POST   | User login             | `{email, password, callbackURL, rememberMe}`              | `{user, token, refreshToken}` |
| `/sign-up/email`           | POST   | User registration      | `{name, email, password, image, callbackURL, rememberMe}` | `{user, token, refreshToken}` |
| `/sign-out`                | POST   | User logout            | `{}`                                                      | `{message}`                   |
| `/get-session`             | GET    | Get current session    | -                                                         | `{user, token}` or `null`     |
| `/forget-password`         | POST   | Request password reset | `{email}`                                                 | `{message}`                   |
| `/reset-password`          | POST   | Reset password         | `{newPassword, token}`                                    | `{message}`                   |
| `/verify-email`            | GET    | Verify email address   | `?token=xxx`                                              | `{message}`                   |
| `/send-verification-email` | POST   | Resend verification    | `{}`                                                      | `{message}`                   |

### 🏠 Home & Services Endpoints

**Base URL**: `https://api.servicebooking.com/v1`

| Endpoint               | Method | Purpose                | Query Parameters                | Response                             |
| ---------------------- | ------ | ---------------------- | ------------------------------- | ------------------------------------ |
| `/services`            | GET    | Get all services       | `?category=xxx&page=1&limit=20` | `{services: [], total, page, limit}` |
| `/services/categories` | GET    | Get service categories | -                               | `{categories: []}`                   |
| `/services/{id}`       | GET    | Get service by ID      | -                               | `{service}`                          |
| `/services/search`     | GET    | Search services        | `?q=query&category=xxx`         | `{services: []}`                     |

### 📅 Booking & Provider Endpoints

**Base URL**: `https://api.servicebooking.com/v1`

| Endpoint                  | Method | Purpose              | Request Body                                                       | Response                |
| ------------------------- | ------ | -------------------- | ------------------------------------------------------------------ | ----------------------- |
| `/bookings`               | POST   | Create booking       | `{serviceId, providerId, schedule, location, budget, notes}`       | `{booking}`             |
| `/bookings`               | GET    | Get user bookings    | `?status=xxx&page=1`                                               | `{bookings: [], total}` |
| `/bookings/{id}`          | GET    | Get booking by ID    | -                                                                  | `{booking}`             |
| `/bookings/{id}`          | PUT    | Update booking       | `{status, schedule, notes}`                                        | `{booking}`             |
| `/bookings/{id}`          | DELETE | Cancel booking       | -                                                                  | `{message}`             |
| `/providers`              | GET    | Get providers        | `?serviceId=xxx&location=xxx&rating=xxx&priceMin=xxx&priceMax=xxx` | `{providers: []}`       |
| `/providers/{id}`         | GET    | Get provider details | -                                                                  | `{provider}`            |
| `/providers/{id}/reviews` | GET    | Get provider reviews | `?page=1&limit=10`                                                 | `{reviews: [], total}`  |

### 📍 Location Endpoints

**Base URL**: `http://192.168.1.7:3000/api/location` (Development)
**Production URL**: `https://api.servicebooking.com/v1/locations`

| Endpoint               | Method | Purpose                 | Request Body                              | Response          |
| ---------------------- | ------ | ----------------------- | ----------------------------------------- | ----------------- |
| `/add`                 | POST   | Add new location        | `{name, address, coordinates, isPrimary}` | `{location}`      |
| `/{id}`                | PATCH  | Update location         | `{name, address, coordinates, isPrimary}` | `{location}`      |
| `/{id}`                | DELETE | Delete location         | -                                         | `{message}`       |
| `/{id}`                | GET    | Get location by ID      | -                                         | `{location}`      |
| `/`                    | GET    | Get all locations       | -                                         | `{locations: []}` |
| `/{id}/change-primary` | PATCH  | Set as primary location | -                                         | `{location}`      |

### 🔔 Notification Endpoints

**Base URL**: `https://api.servicebooking.com/v1`

| Endpoint                      | Method | Purpose                | Query Parameters              | Response                     |
| ----------------------------- | ------ | ---------------------- | ----------------------------- | ---------------------------- |
| `/notifications`              | GET    | Get notifications      | `?type=xxx&status=xxx&page=1` | `{notifications: [], total}` |
| `/notifications/{id}`         | GET    | Get notification by ID | -                             | `{notification}`             |
| `/notifications/{id}/read`    | PATCH  | Mark as read           | -                             | `{message}`                  |
| `/notifications/read-all`     | PATCH  | Mark all as read       | -                             | `{message}`                  |
| `/notifications/{id}/archive` | PATCH  | Archive notification   | -                             | `{message}`                  |
| `/notifications/{id}`         | DELETE | Delete notification    | -                             | `{message}`                  |
| `/notifications/unread-count` | GET    | Get unread count       | -                             | `{count}`                    |

### 👤 Profile Endpoints

**Base URL**: `https://api.servicebooking.com/v1`

| Endpoint                  | Method | Purpose              | Request Body                       | Response     |
| ------------------------- | ------ | -------------------- | ---------------------------------- | ------------ |
| `/profile`                | GET    | Get user profile     | -                                  | `{profile}`  |
| `/profile`                | PUT    | Update profile       | `{name, email, phone, image, bio}` | `{profile}`  |
| `/profile/password`       | PUT    | Change password      | `{currentPassword, newPassword}`   | `{message}`  |
| `/providers/{id}/profile` | GET    | Get provider profile | -                                  | `{provider}` |

### 📝 Task Posting Endpoints

**Base URL**: `https://api.servicebooking.com/v1`

| Endpoint      | Method | Purpose        | Request Body                                                                           | Response             |
| ------------- | ------ | -------------- | -------------------------------------------------------------------------------------- | -------------------- |
| `/tasks`      | POST   | Create task    | `{title, description, category, subcategory, location, budget, schedule, contactInfo}` | `{task}`             |
| `/tasks`      | GET    | Get user tasks | `?status=xxx&page=1`                                                                   | `{tasks: [], total}` |
| `/tasks/{id}` | GET    | Get task by ID | -                                                                                      | `{task}`             |
| `/tasks/{id}` | PUT    | Update task    | `{title, description, budget, schedule}`                                               | `{task}`             |
| `/tasks/{id}` | DELETE | Delete task    | -                                                                                      | `{message}`          |

### 🔧 API Configuration

#### Authentication

- **Token Management**: Automatic token refresh using refresh tokens
- **Headers**: `Authorization: Bearer {token}` for authenticated requests
- **Session Storage**: Tokens stored securely in SharedPreferences

#### Error Handling

- **HTTP Status Codes**: Proper error handling for 400, 401, 403, 404, 500
- **Error Messages**: User-friendly error messages from API responses
- **Retry Logic**: Automatic retry for network failures (3 attempts)

#### Request/Response Format

```json
// Success Response
{
  "success": true,
  "data": { ... },
  "message": "Operation successful"
}

// Error Response
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": { ... }
  }
}
```

### 🚀 Backend Integration Steps

1. **Replace Mock Data**: Update all `*_api_impl.dart` files to use real API calls
2. **Configure Base URLs**: Update `AppConstants.baseUrl` with production URL
3. **Add Authentication**: Implement token management in `DioClient`
4. **Error Handling**: Add proper error handling for all API responses
5. **Testing**: Test all endpoints with real backend data
6. **Environment Configuration**: Set up different URLs for dev/staging/production

### 📱 Current Mock Data Status

- ✅ **Authentication**: Fully implemented with mock data
- ✅ **Home/Services**: Mock data with real API structure
- ✅ **Booking**: Mock data with real API structure
- ✅ **Location**: Real API implementation (development server)
- ❌ **Notifications**: Mock data only - needs real API
- ❌ **Profile**: Mock data only - needs real API
- ❌ **Task Posting**: Mock data only - needs real API

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
