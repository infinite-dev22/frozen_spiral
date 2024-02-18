abstract class InvoiceItemRepoInterface {
  Future<dynamic> fetch(int id);

  Future<dynamic> fetchAll({Map<String, dynamic>? body});

  Future<dynamic> put(Map<String, dynamic> data, int id);

  Future<dynamic> post(Map<String, dynamic> data, int id);
}
