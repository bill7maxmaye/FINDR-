abstract class TaskPostingEvent {}

class TaskPostingInitialize extends TaskPostingEvent {}

class TaskPostingUpdateTitle extends TaskPostingEvent {
  final String title;
  TaskPostingUpdateTitle(this.title);
}

class TaskPostingUpdateSummary extends TaskPostingEvent {
  final String summary;
  TaskPostingUpdateSummary(this.summary);
}

class TaskPostingUpdateCategory extends TaskPostingEvent {
  final String category;
  final String subcategory;
  TaskPostingUpdateCategory(this.category, this.subcategory);
}

class TaskPostingUpdateLocation extends TaskPostingEvent {
  final String location;
  TaskPostingUpdateLocation(this.location);
}

class TaskPostingUpdateBudget extends TaskPostingEvent {
  final double? budget;
  TaskPostingUpdateBudget(this.budget);
}

class TaskPostingUpdatePreferredDate extends TaskPostingEvent {
  final DateTime? preferredDate;
  TaskPostingUpdatePreferredDate(this.preferredDate);
}

class TaskPostingAddImage extends TaskPostingEvent {
  final String imagePath;
  TaskPostingAddImage(this.imagePath);
}

class TaskPostingRemoveImage extends TaskPostingEvent {
  final int index;
  TaskPostingRemoveImage(this.index);
}

class TaskPostingSubmit extends TaskPostingEvent {}

class TaskPostingUpdateStep extends TaskPostingEvent {
  final int step;
  TaskPostingUpdateStep(this.step);
}

class TaskPostingNextStep extends TaskPostingEvent {}

class TaskPostingPreviousStep extends TaskPostingEvent {}

class TaskPostingReset extends TaskPostingEvent {}
