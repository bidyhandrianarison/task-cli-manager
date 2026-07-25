import 'dart:io';

import 'package:task_manager/exceptions/duplicated_task_exception.dart';
import 'package:task_manager/models/normal_task.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'package:task_manager/utils/priority.dart';
import 'package:test/test.dart';

void main() {
  late Directory tempDir;
  late File file;
  late TaskRepository repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    file = File('${tempDir.path}/tasks.json');

    repository = TaskRepository(file);

    await repository.load();
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('add ajoute une tâche', () async {
    final task = NormalTask(
      id: 1,
      title: 'Apprendre Dart',
      priority: Priority.high,
    );

    await repository.add(task);

    final tasks = await repository.findAll();

    expect(tasks.length, 1);
    expect(tasks.first.id, 1);
    expect(tasks.first.title, 'Apprendre Dart');
  });

  test('add refuse une tâche avec un ID déjà existant', () async {
    final task1 = NormalTask(
      id: 1,
      title: 'Première tâche',
      priority: Priority.high,
    );

    final task2 = NormalTask(
      id: 1,
      title: 'Deuxième tâche',
      priority: Priority.low,
    );

    await repository.add(task1);

    expect(
      () => repository.add(task2),
      throwsA(isA<DuplicatedTaskException>()),
    );
  });

  test('findById retourne la tâche correspondant à son ID', () async {
    final task = NormalTask(
      id: 1,
      title: 'Apprendre Dart',
      priority: Priority.high,
    );

    await repository.add(task);

    final result = await repository.findById(1);

    expect(result, isNotNull);
    expect(result!.id, 1);
    expect(result.title, 'Apprendre Dart');
  });

  test('update modifie une tâche existante', () async {
    final task = NormalTask(
      id: 1,
      title: 'Apprendre Dart',
      priority: Priority.low,
    );

    await repository.add(task);

    final updatedTask = NormalTask(
      id: 1,
      title: 'Apprendre Dart avancé',
      priority: Priority.high,
    );

    await repository.update(updatedTask);

    final result = await repository.findById(1);

    expect(result, isNotNull);
    expect(result!.title, 'Apprendre Dart avancé');
    expect(result.priority, Priority.high);
  });

  test('delete supprime une tâche existante', () async {
    final task = NormalTask(
      id: 1,
      title: 'Tâche à supprimer',
      priority: Priority.low,
    );

    await repository.add(task);

    await repository.delete(1);

    final result = await repository.findById(1);

    expect(result, isNull);
  });

  test('markAsDone marque une tâche comme terminée', () async {
    final task = NormalTask(
      id: 1,
      title: 'Tâche à terminer',
      priority: Priority.high,
    );

    await repository.add(task);

    expect(task.isDone, false);

    await repository.markAsDone(task);

    final result = await repository.findById(1);

    expect(result, isNotNull);
    expect(result!.isDone, true);
  });
}
