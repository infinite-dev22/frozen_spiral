import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/client/client_repo.dart';

class ClientApi {
  static Future<List<SmartClient>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    ClientRepo clientRepo = ClientRepo();
    List<SmartClient> clients = List.empty(growable: true);

    var response = await clientRepo.fetchAll();
    List clientsMap = response['clients'];

    if (clientsMap.isNotEmpty) {
      clients = clientsMap
          .map(
            (client) => SmartClient.fromJson(client),
          )
          .toList();
    }

    preloadedClients.clear();
    preloadedClients.addAll(clients);
    return preloadedClients;
  }

  static Future<SmartClient?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    ClientRepo clientRepo = ClientRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartClient? client;
    await clientRepo.fetch(id).then((response) {
      client = SmartClient.fromJson(response['client']);
    });

    return client;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    ClientRepo clientRepo = ClientRepo();
    var response = await clientRepo
        .post(data, id)
        .then((value) => onSuccess)
        .onError((error, stackTrace) => onError);
    return response;
  }

  static Future process(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    ClientRepo clientRepo = ClientRepo();
    var response = await clientRepo
        .process(data, id)
        .then((value) => onSuccess)
        .onError((error, stackTrace) => onError);
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    ClientRepo clientRepo = ClientRepo();
    // List<SmartClient> clients = List.empty(growable: true);

    var response = await clientRepo.put(data, id);
    // List clientsMap = response['search']['clients'];
    //
    // if (clientsMap.isNotEmpty) {
    //   clients = clientsMap
    //       .map(
    //         (client) => SmartClient.fromJson(client),
    //       )
    //       .toList();
    // }
    //
    // preloadedClients = clients;
    return response;
  }
}
