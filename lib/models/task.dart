import 'package:task_manager/interfaces/json_serializable.dart';
import 'package:task_manager/utils/priority.dart';
import 'package:task_manager/utils/task_type.dart';

abstract class Task implements JsonSerializable {
  final int id;
  final String title;
  final Priority priority;
  final DateTime? deadline;
  bool isDone;
  TaskType get type;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
  });

  @override
  String toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
    };
  }
}
