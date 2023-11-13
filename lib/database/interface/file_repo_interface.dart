abstract class FileRepoInterface {
  Future<Map<String, dynamic>> fetch(int id);

  Future<Map<String, dynamic>> fetchAll();

  Future<dynamic> put(Map<String, dynamic> data, int id);

  Future<dynamic> post(Map<String, dynamic> data, int id);

  Future<Map<String, dynamic>> filter();
}
