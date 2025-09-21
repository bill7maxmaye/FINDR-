class Task {
  final String id;
  final String title;
  final String summary;
  final String category;
  final String subcategory;
  final String location;
  final double? budget;
  final DateTime? preferredDate;
  final List<String> images;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.subcategory,
    required this.location,
    this.budget,
    this.preferredDate,
    required this.images,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? summary,
    String? category,
    String? subcategory,
    String? location,
    double? budget,
    DateTime? preferredDate,
    List<String>? images,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      preferredDate: preferredDate ?? this.preferredDate,
      images: images ?? this.images,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.summary == summary &&
        other.category == category &&
        other.subcategory == subcategory &&
        other.location == location &&
        other.budget == budget &&
        other.preferredDate == preferredDate &&
        other.images == images &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        category.hashCode ^
        subcategory.hashCode ^
        location.hashCode ^
        budget.hashCode ^
        preferredDate.hashCode ^
        images.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
