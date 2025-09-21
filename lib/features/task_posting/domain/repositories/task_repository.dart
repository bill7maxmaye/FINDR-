import '../entities/task.dart';

abstract class TaskRepository {
  Future<Task> createTask(Task task);
  Future<List<Task>> getUserTasks();
  Future<Task> getTaskById(String id);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(String id);
}
