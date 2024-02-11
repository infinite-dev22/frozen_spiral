abstract class ClientRepoInterface {
  Future<dynamic> fetch(int id);

  Future<dynamic> fetchAll();

  Future<dynamic> put(Map<String, dynamic> data, int id);

  Future<dynamic> post(Map<String, dynamic> data, int id);

  Future<dynamic> process(Map<String, dynamic> data, int id);
}
