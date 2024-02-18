abstract class EngagementRepoInterface {
  Future<dynamic> fetch(int id);

  Future<dynamic> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> post(Map<String, dynamic> data, int id);
}
