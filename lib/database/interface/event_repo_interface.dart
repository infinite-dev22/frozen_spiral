abstract class EventRepoInterface {
  Future<dynamic> fetchAll({Map<String, dynamic>? body,
        Function()? onSuccess,
        Function()? onError});
}
