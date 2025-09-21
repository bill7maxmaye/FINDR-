import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.category,
    required super.subcategory,
    required super.location,
    super.budget,
    super.preferredDate,
    required super.images,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] as String,
      location: json['location'] as String,
      budget: json['budget']?.toDouble(),
      preferredDate: json['preferredDate'] != null 
          ? DateTime.parse(json['preferredDate'] as String)
          : null,
      images: List<String>.from(json['images'] as List),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'category': category,
      'subcategory': subcategory,
      'location': location,
      'budget': budget,
      'preferredDate': preferredDate?.toIso8601String(),
      'images': images,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      summary: task.summary,
      category: task.category,
      subcategory: task.subcategory,
      location: task.location,
      budget: task.budget,
      preferredDate: task.preferredDate,
      images: task.images,
      status: task.status,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}
