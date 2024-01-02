import '../../../data/app_config.dart';
import '../../../database/activity/activity_model.dart';
import '../../../database/activity/activty_repo.dart';

class ActivityApi {
  static Future<List<SmartActivity>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    ActivityRepo activityRepo = ActivityRepo();
    List<SmartActivity> activities = List.empty(growable: true);

    var response = await activityRepo.fetchAll();
    List activitiesMap = response['caseActivites'];

    if (activitiesMap.isNotEmpty) {
      activities = activitiesMap
          .map(
            (activity) => SmartActivity.fromJson(activity),
          )
          .toList();
    }

    preloadedActivities.clear();
    preloadedActivities = activities;
    return activities;
  }

  static Future<SmartActivity> fetch(int fileId, int activityId,
      {Function()? onSuccess, Function()? onError}) async {
    ActivityRepo activityRepo = ActivityRepo();
    SmartActivity activity;

    Map response = await activityRepo.fetch(fileId, activityId);

    activity = SmartActivity.fromJson(response['caseActivity']);

    return activity;
  }

  static post(Map<String, dynamic> data, int fileId,
      {Function()? onSuccess, Function()? onError}) async {
    ActivityRepo activityRepo = ActivityRepo();
    // List<SmartActivity> activities = List.empty(growable: true);

    var response = await activityRepo.post(data, fileId);
    // List activitiesMap = response['search']['activities'];
    // if (activitiesMap.isNotEmpty) {
    //   activities = activitiesMap
    //       .map(
    //         (activity) => SmartActivity.fromJson(activity),
    //       )
    //       .toList();
    // }
    // preloadedActivities = activities;
    return response;
  }

  static put(Map<String, dynamic> data, int fileId, int activityId,
      {Function()? onSuccess, Function()? onError}) async {
    ActivityRepo activityRepo = ActivityRepo();
    var response = await activityRepo.put(data, fileId, activityId);
    ActivityApi.fetchAll(); // TODO: Remove when bloc is successfully added.

    return response;
  }
}
