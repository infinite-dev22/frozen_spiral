import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/task/task_model.dart';
import 'package:smart_case/database/task/task_repo.dart';
import 'package:smart_case/database/task/task_repo.dart';

class TaskApi {
  static Future<List<SmartTask>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    TaskRepo taskRepo = TaskRepo();
    List<SmartTask> tasks = List.empty(growable: true);

    var response = await taskRepo.fetchAll(page: page);
    List tasksMap = response['data'];

    if (tasksMap.isNotEmpty) {
      tasks = tasksMap
          .map(
            (task) => SmartTask.fromJson(task),
          )
          .toList();
    }

    if (page == 1) {
      preloadedTasks.clear();
    }
    preloadedTasks.addAll(tasks);
    return tasks;
  }

  static Future<SmartTask?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaskRepo taskRepo = TaskRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartTask? task;
    List drawersList;
    await taskRepo.fetch(id).then((response) {
      task = SmartTask.fromJson(response['task']);

      try {
        drawersList = response['drawers'];
        preloadedDrawers =
            drawersList.map((drawer) => SmartDrawer.fromJson(drawer)).toList();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    // SmartDrawer drawer = await drawerRepo
    //     .fetch(id)
    //     .then((response) => SmartDrawer.fromJson(response['drawer']));

    return task;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaskRepo taskRepo = TaskRepo();
    var response = await taskRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static Future process(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaskRepo taskRepo = TaskRepo();
    var response = await taskRepo
        .process(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaskRepo taskRepo = TaskRepo();

    var response = await taskRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
