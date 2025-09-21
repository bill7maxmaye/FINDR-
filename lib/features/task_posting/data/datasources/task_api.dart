import '../models/task_model.dart';

abstract class TaskApi {
  Future<TaskModel> createTask(TaskModel task);
  Future<List<TaskModel>> getUserTasks();
  Future<TaskModel> getTaskById(String id);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class TaskApiImpl implements TaskApi {
  // TODO: Implement actual API calls
  // For now, this is a mock implementation
  
  @override
  Future<TaskModel> createTask(TaskModel task) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock response - in real implementation, this would be an API call
    return task.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: 'pending',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ) as TaskModel;
  }

  @override
  Future<List<TaskModel>> getUserTasks() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock response - return empty list for now
    return [];
  }

  @override
  Future<TaskModel> getTaskById(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock response - in real implementation, this would be an API call
    throw UnimplementedError('getTaskById not implemented');
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock response - in real implementation, this would be an API call
    return task.copyWith(updatedAt: DateTime.now()) as TaskModel;
  }

  @override
  Future<void> deleteTask(String id) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock response - in real implementation, this would be an API call
  }
}
