import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_api.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskApi api;

  TaskRepositoryImpl({required this.api});

  @override
  Future<Task> createTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final createdTask = await api.createTask(taskModel);
    return createdTask;
  }

  @override
  Future<List<Task>> getUserTasks() async {
    final tasks = await api.getUserTasks();
    return tasks;
  }

  @override
  Future<Task> getTaskById(String id) async {
    final task = await api.getTaskById(id);
    return task;
  }

  @override
  Future<Task> updateTask(Task task) async {
    final taskModel = TaskModel.fromEntity(task);
    final updatedTask = await api.updateTask(taskModel);
    return updatedTask;
  }

  @override
  Future<void> deleteTask(String id) async {
    await api.deleteTask(id);
  }
}
