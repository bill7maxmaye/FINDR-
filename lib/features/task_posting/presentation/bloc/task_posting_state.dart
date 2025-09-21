import '../../domain/entities/task.dart';

abstract class TaskPostingState {}

class TaskPostingInitial extends TaskPostingState {}

class TaskPostingLoading extends TaskPostingState {}

class TaskPostingLoaded extends TaskPostingState {
  final String title;
  final String summary;
  final String category;
  final String subcategory;
  final String location;
  final double? budget;
  final DateTime? preferredDate;
  final List<String> images;
  final int currentStep;

  TaskPostingLoaded({
    this.title = '',
    this.summary = '',
    this.category = '',
    this.subcategory = '',
    this.location = '',
    this.budget,
    this.preferredDate,
    this.images = const [],
    this.currentStep = 0,
  });

  TaskPostingLoaded copyWith({
    String? title,
    String? summary,
    String? category,
    String? subcategory,
    String? location,
    double? budget,
    DateTime? preferredDate,
    List<String>? images,
    int? currentStep,
  }) {
    return TaskPostingLoaded(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      preferredDate: preferredDate ?? this.preferredDate,
      images: images ?? this.images,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  bool get canProceedToNextStep {
    switch (currentStep) {
      case 0: // Location + Details step
        return location.isNotEmpty && title.isNotEmpty && summary.isNotEmpty;
      case 1: // Budget and Date step
        return true; // No validation needed - all fields are optional
      default:
        return false;
    }
  }

  bool get isFormComplete {
    return title.isNotEmpty && 
           summary.isNotEmpty && 
           category.isNotEmpty && 
           subcategory.isNotEmpty && 
           location.isNotEmpty;
  }
}

class TaskPostingSuccess extends TaskPostingState {
  final Task task;
  TaskPostingSuccess(this.task);
}

class TaskPostingError extends TaskPostingState {
  final String message;
  TaskPostingError(this.message);
}
