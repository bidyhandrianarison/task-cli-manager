import 'package:task_manager/exceptions/task_not_found_exception.dart';
import 'package:task_manager/models/normal_task.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/urgent_task.dart';
import 'package:task_manager/repositories/task_repository.dart';
import 'dart:io';

import 'package:task_manager/utils/priority.dart';
import 'package:task_manager/utils/task_type.dart';

class TaskCli {
  final TaskRepository repository;
  TaskCli(this.repository);

  Future<void> addTask() async {
    Priority? priorityEnum;
    stdout.write('Titre de la tâche: ');
    final title = stdin.readLineSync();
    if (title == null || title.trim().isEmpty) {
      print('Le titre ne peut pas être vide.');
      return;
    }

    while (priorityEnum == null) {
      stdout.write('Priorité (low / medium / high) : ');
      final priority = stdin.readLineSync();
      try {
        priorityEnum = Priority.values.byName(priority!);
      } catch (e) {
        priorityEnum = null;
      }
    }

    // Deadline
    DateTime? deadlineDate;
    while (true) {
      stdout.write('Deadline (optionnel) : ');
      final deadline = stdin.readLineSync();

      if (deadline == null || deadline.trim().isEmpty) {
        break;
      }

      try {
        deadlineDate = DateTime.parse(deadline);
        break;
      } on FormatException {
        print('Deadline invalide. Utilisez par exemple : 2026-08-15');
      }
    }

    //TYPE
    TaskType? taskType;
    while (taskType == null) {
      stdout.write('Type (normal / urgent) :');
      final type = stdin.readLineSync();
      try {
        taskType = TaskType.values.byName(type!);
      } catch (e) {
        print('Type invalide. Utilisez par exemple : normal');
      }
    }

    // GENERATION de l ID
    int newId = 0;
    final allTasks = await repository.findAll();
    for (var task in allTasks) {
      if (task.id > newId) {
        newId = task.id;
      }
    }
    newId++;
    // CREATION de la TACHE
    final Task newTask;
    switch (taskType) {
      case TaskType.normal:
        newTask = NormalTask(
          id: newId,
          title: title,
          priority: priorityEnum,
          deadline: deadlineDate,
        );
        break;
      case TaskType.urgent:
        newTask = UrgentTask(
          id: newId,
          title: title,
          priority: priorityEnum,
          deadline: deadlineDate,
        );
        break;
    }
    await repository.add(newTask);
  }

  Future<void> listTasks() async {
    // Récupérer toutes les tâches depuis le repository
    final allTasks = await repository.findAll();
    if (allTasks.isEmpty) {
      print('Aucune tâche à afficher.');
      return;
    }
    stdout.write('''

  Trier les tâches par :
  1. Priorité
  2. Date
  3. Sans tri

  Votre choix :
  ''');
    final choice = stdin.readLineSync();
    final tasks = allTasks.toList();

    switch (choice) {
      case '1':
        tasks.sort((a, b) {
          return b.priority.index.compareTo(a.priority.index);
        });
        break;

      case '2':
        tasks.sort((a, b) {
          if (a.deadline == null && b.deadline == null) {
            return 0;
          }

          if (a.deadline == null) {
            return 1;
          }

          if (b.deadline == null) {
            return -1;
          }

          return a.deadline!.compareTo(b.deadline!);
        });
        break;

      case '3':
        break;

      default:
        print('Choix invalide.');
        return;
    }
    for (var task in tasks) {
      print(task);
    }
  }

  // MARQUER COMME TERMINÉE
  Future<void> markAsDone() async {
    stdout.write('ID de la tâche que tu veux marquer comme terminée : ');

    final id = int.tryParse(stdin.readLineSync() ?? '');

    if (id == null || id <= 0) {
      print('ID invalide.');
      return;
    }

    final task = await repository.findById(id);

    if (task == null) {
      print('Tâche non trouvée.');
      return;
    }

    await repository.markAsDone(task);
    print('Tâche marquée comme terminée.');
  }

  // SUPPRIMER
  Future<void> deleteTask() async {
    stdout.write('Id de la tâche que tu veux supprimer : ');
    final id = int.tryParse(stdin.readLineSync() ?? '');
    if (id != null && id > 0) {
      try {
        await repository.delete(id);
      } on TaskNotFoundException {
        print('Tâche non trouvée.');
      }
    }
  }

  Future<void> start() async {
    String? choice;
    final String menu = '''
    ========================
          TASK MANAGER
    ========================
    1. Ajouter une tâche
    2. Lister les tâches
    3. Marquer comme terminée
    4. Supprimer une tâche
    5. Quitter

    Votre choix :
    ''';
    do {
      print(menu);
      choice = stdin.readLineSync();
      switch (choice) {
        case '1':
          await addTask();
          break;
        case '2':
          await listTasks();
          break;
        case '3':
          await markAsDone();
          break;
        case '4':
          await deleteTask();
          break;
        case '5':
          print('Quitter');
          break;
        default:
          print('Choix invalide');
          break;
      }
    } while (choice != '5');
  }
}
