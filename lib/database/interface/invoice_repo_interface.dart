abstract class InvoiceRepoInterface {
  Future<Map<String, dynamic>> fetch(int id);

  Future<Map<String, dynamic>> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> put(Map<String, dynamic> data, int id);

  Future<dynamic> post(Map<String, dynamic> data);

  Future<Map<String, dynamic>> filter();
}
