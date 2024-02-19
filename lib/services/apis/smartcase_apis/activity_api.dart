import '../../../data/app_config.dart';
import '../../../database/activity/activity_model.dart';
import '../../../database/activity/activty_repo.dart';

class ActivityApi {
  static Future<List<SmartActivity>> fetchAll() async {
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

  static Future<SmartActivity> fetch(int fileId, int activityId) async {
    ActivityRepo activityRepo = ActivityRepo();
    SmartActivity activity;

    Map response = await activityRepo.fetch(fileId, activityId);

    activity = SmartActivity.fromJson(response['caseActivity']);

    return activity;
  }

  static post(Map<String, dynamic> data, int fileId) async {
    ActivityRepo activityRepo = ActivityRepo();
    var response = await activityRepo.post(data, fileId);
    return response;
  }

  static put(Map<String, dynamic> data, int fileId, int activityId) async {
    ActivityRepo activityRepo = ActivityRepo();
    var response = await activityRepo.put(data, fileId, activityId);
    return response;
  }

  static delete(int fileId, int activityId) async {
    ActivityRepo activityRepo = ActivityRepo();
    var response = await activityRepo.delete(fileId, activityId);
    return response;
  }
}
