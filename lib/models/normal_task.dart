import 'package:task_manager/models/task.dart';

class NormalTask extends Task {
  NormalTask({
    required super.id,
    required super.type,
    required super.title,
    required super.priority,
    super.deadline,
    super.isDone,
  });
}
