import 'package:flutter/foundation.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';

import '../../../data/app_config.dart';
import '../../../database/engagement/engagement_model.dart';
import '../../../database/engagement/engagement_repo.dart';

class EngagementApi {
  static Future<List<SmartEngagement>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    List<SmartEngagement> engagements = List.empty(growable: true);

    var response = await engagementRepo.fetchAll(page: page);
    List engagementsMap = response['engagementypes'];

    if (engagementsMap.isNotEmpty) {
      engagements = engagementsMap
          .map(
            (engagement) => SmartEngagement.fromJson(engagement),
          )
          .toList();
    }

    preloadedEngagements.addAll(engagements);
    return engagements;
  }

  static Future<SmartEngagement?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartEngagement? engagement;
    List drawersList;
    await engagementRepo.fetch(id).then((response) {
      engagement = SmartEngagement.fromJson(response['engagement']);

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

    return engagement;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    var response = await engagementRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static Future process(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    var response = await engagementRepo
        .process(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();

    var response = await engagementRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static delete(int id, {Function()? onSuccess, Function()? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();

    var response = await engagementRepo
        .delete(id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
