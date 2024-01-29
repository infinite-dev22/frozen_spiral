import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/database/event/event_repo.dart';

class EventApi {
  static Future<List<SmartEvent>> fetchAll(Map<String, dynamic> body,
      {Function()? onSuccess, Function? onError}) async {
    EventRepo eventRepo = EventRepo();
    List<SmartEvent> events = List.empty(growable: true);

    var response = await eventRepo.fetchAll(body);
    List eventsMap = response['data'];

    if (eventsMap.isNotEmpty) {
      events = eventsMap
          .map(
            (event) => SmartEvent.fromJson(event),
          )
          .toList();
    }

    preloadedEvents.clear();
    return events;
  }

  static Future<SmartEvent?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    EventRepo eventRepo = EventRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartEvent? event;
    List drawersList;
    await eventRepo.fetch(id).then((response) {
      event = SmartEvent.fromJson(response['event']);

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

    return event;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EventRepo eventRepo = EventRepo();
    var response = await eventRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static Future process(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EventRepo eventRepo = EventRepo();
    var response = await eventRepo
        .process(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EventRepo eventRepo = EventRepo();

    var response = await eventRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
