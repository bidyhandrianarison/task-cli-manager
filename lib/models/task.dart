import 'package:cli_manager/models/priority.dart';
abstract class Task {
  final int id;
  final String title;
  final Priority priority;
  final DateTime? deadline;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.deadline,
    this.isDone = false,
  });
  @override
  String toString();
}
