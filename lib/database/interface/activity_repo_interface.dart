abstract class ActivityRepoInterface {
  Future<Map<String, dynamic>> fetch(int fileId, int activityId);

  Future<Map<String, dynamic>> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> put(Map<String, dynamic> data, int fileId, int activityId);

  Future<dynamic> post(Map<String, dynamic> data, int fileId);

  Future<dynamic> delete(int fileId, int activityId);

  Future<Map<String, dynamic>> filter();
}
