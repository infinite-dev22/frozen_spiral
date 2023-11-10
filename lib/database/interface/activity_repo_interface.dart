abstract class ActivityRepoInterface {
  Future<Map<String, dynamic>> fetch(int id);

  Future<Map<String, dynamic>> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> put(Map<String, dynamic> data, int fileId, int activityId);

  Future<dynamic> post(Map<String, dynamic> data, int fileId);

  Future<Map<String, dynamic>> filter();
}
