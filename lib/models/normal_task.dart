import 'package:task_manager/models/task.dart';
import 'package:task_manager/utils/task_type.dart';

class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
  });
  @override
  String get displayPrefix => '';

  @override
  TaskType get type => TaskType.normal;
}
