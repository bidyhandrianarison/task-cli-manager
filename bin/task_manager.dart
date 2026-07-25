import 'dart:io';

import 'package:task_manager/cli/task_cli.dart';
import 'package:task_manager/repositories/task_repository.dart';

Future<void> main(List<String> arguments) async {
  final File file = File('tasks.json');
  final TaskRepository taskRepository = TaskRepository(file);
  await taskRepository.load();
  final TaskCli taskCli = TaskCli(taskRepository);
  await taskCli.start();
}
