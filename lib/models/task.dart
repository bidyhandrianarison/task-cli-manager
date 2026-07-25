import 'package:task_manager/exceptions/invalid_task_exception.dart';
import 'package:task_manager/interfaces/json_serializable.dart';
import 'package:task_manager/models/normal_task.dart';
import 'package:task_manager/models/urgent_task.dart';
import 'package:task_manager/utils/priority.dart';
import 'package:task_manager/utils/task_type.dart';

abstract class Task implements JsonSerializable {
  final int id;
  final String title;
  final Priority priority;
  final DateTime? deadline;
  bool isDone;
  TaskType get type;
  String get displayPrefix;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
  });

  @override
  String toString() {
    final deadlineText = deadline != null
        ? deadline!.toIso8601String()
        : 'Pas de deadline';

    final status = isDone ? 'Terminée' : 'À faire';

    return '[$id] $displayPrefix | $title | '
        '${priority.name.toUpperCase()} | '
        'Deadline: $deadlineText | $status';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority.name,
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
      'type': type.name,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    try {
      final priority = Priority.values.byName(json['priority']);
      final type = TaskType.values.byName(json['type']);
      final deadline = json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : null;
      switch (type) {
        case TaskType.normal:
          return NormalTask(
            id: json['id'],
            title: json['title'],
            priority: priority,
            deadline: deadline,
            isDone: json['isDone'],
          );
        case TaskType.urgent:
          return UrgentTask(
            id: json['id'],
            title: json['title'],
            priority: priority,
            deadline: deadline,
            isDone: json['isDone'],
          );
      }
    } on ArgumentError {
      throw InvalidTaskException('Invalid task data in JSON');
    }
  }
}
