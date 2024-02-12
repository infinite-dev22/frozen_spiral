abstract class InvoiceRepoInterface {
  Future<dynamic> fetch(int id);

  Future<dynamic> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> put(Map<String, dynamic> data, int id);

  Future<dynamic> post(Object data);
}
