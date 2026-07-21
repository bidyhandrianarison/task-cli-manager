import 'package:task_manager/models/task.dart';
import 'package:task_manager/utils/task_type.dart';

class UrgentTask extends Task {
  UrgentTask({
    required super.id,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
  });
  @override
  TaskType get type => TaskType.urgent;

  @override
  String get displayPrefix => '🔥';

  @override
  String toString() {
    // TODO: implement toString
    return '$displayPrefix...';
  }
}
