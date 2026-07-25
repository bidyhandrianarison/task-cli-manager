import 'dart:convert';
import 'dart:io';

import 'package:task_manager/exceptions/duplicated_task_exception.dart';
import 'package:task_manager/exceptions/invalid_task_exception.dart';
import 'package:task_manager/exceptions/task_not_found_exception.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/repositories/repository.dart';

class TaskRepository implements Repository<Task> {
  final File _file;
  final List<Task> _tasks = [];

  @override
  Future<void> load() async {
    _tasks.clear();
    if (await _file.exists()) {
      final content = await _file.readAsString();
      try {
        final List<dynamic> data = jsonDecode(content);
        for (final item in data) {
          _tasks.add(Task.fromJson(item as Map<String, dynamic>));
        }
      } on FormatException {
        throw InvalidTaskException('Invalid JSON format');
      }
    } else {
      await _file.create(recursive: true);
      await _file.writeAsString('[]');
      return;
    }
  }

  @override
  Future<int> findIndexById(int id) async {
    return _tasks.indexWhere((task) => task.id == id);
  }

  Future<void> _save() async {
    final List<Map<String, dynamic>> jsonTasks = _tasks
        .map((task) => task.toJson())
        .toList();
    final content = jsonEncode(jsonTasks);
    await _file.writeAsString(content);
  }

  @override
  Future<List<Task>> findAll() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task?> findById(int id) async {
    for (final task in _tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  @override
  Future<void> add(Task task) async {
    final newTask = await findById(task.id);
    if (newTask != null) {
      throw DuplicatedTaskException('Task already exists');
    } else {
      _tasks.add(task);
      await _save();
    }
  }

  @override
  Future<void> update(Task item) async {
    final taskIndex = await findIndexById(item.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = item;
      await _save();
    } else {
      throw TaskNotFoundException('Task not found');
    }
  }

  @override
  Future<void> delete(int id) async {
    final taskIndex = await findIndexById(id);
    if (taskIndex != -1) {
      _tasks.removeAt(taskIndex);
      await _save();
    } else {
      throw TaskNotFoundException('Task not found');
    }
  }

  Future<void> markAsDone(Task task) async {
    final existingTask = await findById(task.id);
    if (existingTask != null) {
      existingTask.isDone = true;
      await update(existingTask);
    } else {
      throw TaskNotFoundException('Task not found');
    }
  }

  TaskRepository(this._file);
}
