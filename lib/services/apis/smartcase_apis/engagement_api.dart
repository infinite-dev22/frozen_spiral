import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/engagement/engagement_model.dart';
import 'package:smart_case/database/engagement/engagement_repo.dart';

class EngagementApi {
  static Future<List<SmartEngagement>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    EngagementRepo engagementRepo = EngagementRepo();
    List<SmartEngagement> engagements = List.empty(growable: true);

    var response = await engagementRepo.fetchAll();
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
}
