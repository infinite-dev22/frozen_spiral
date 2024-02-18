abstract class ActivityRepoInterface {
  Future<dynamic> fetch(int fileId, int activityId);

  Future<dynamic> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> put(Map<String, dynamic> data, int fileId, int activityId);

  Future<dynamic> post(Map<String, dynamic> data, int fileId);

  Future<dynamic> delete(int fileId, int activityId);
}
