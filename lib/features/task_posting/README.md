# Task Posting Feature

This feature implements a multi-step task posting form inspired by the web version of the FINDR service booking app.

## Architecture

The feature follows Clean Architecture principles with the following structure:

### Domain Layer

- **Entities**: `Task` - Core business entity representing a task
- **Repositories**: `TaskRepository` - Abstract interface for data operations
- **Use Cases**: `CreateTask` - Business logic for creating tasks

### Data Layer

- **Models**: `TaskModel` - Data transfer object with JSON serialization
- **Data Sources**: `TaskApi` - API interface for backend communication
- **Repositories**: `TaskRepositoryImpl` - Concrete implementation of repository

### Presentation Layer

- **BLoC**: `TaskPostingBloc` - State management for the task posting flow
- **Pages**: `TaskPostingPage` - Main page with multi-step form
- **Widgets**:
  - `TaskPostingProgressSidebar` - Step progress indicator
  - `LocationStepWidget` - Location selection step
  - `DetailsStepWidget` - Task details input step
  - `BudgetDateStepWidget` - Budget and date selection step

## Features

### Multi-Step Form

1. **Location Step**: User selects or enters service location
2. **Details Step**: User provides task title, summary, and optional images
3. **Budget and Date Step**: User sets budget and preferred date (both optional)

### UI Design

- Clean, modern design inspired by the web version
- Progress sidebar showing current step and completion status
- Responsive form fields with proper validation
- Image upload functionality (placeholder implementation)
- Consistent theming using `AppTheme`

### State Management

- BLoC pattern for predictable state management
- Form validation at each step
- Navigation between steps with data persistence
- Error handling and loading states

## Usage

Navigate to `/post-task` to access the task posting form. The form includes:

- Step-by-step navigation
- Form validation
- Image upload (placeholder)
- Budget and date selection
- Location integration

## Future Enhancements

- Real image picker integration
- Category selection from existing categories
- Location autocomplete
- Form data persistence across app restarts
- Real API integration
- File upload to cloud storage
