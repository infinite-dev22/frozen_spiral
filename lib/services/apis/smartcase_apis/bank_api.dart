import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/bank/bank_repo.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';

class BankApi {
  static Future<List<SmartBank>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    BankRepo bankRepo = BankRepo();
    List<SmartBank> banks = List.empty(growable: true);

    var response = await bankRepo.fetchAll();
    List banksMap = response['banks'];

    if (banksMap.isNotEmpty) {
      banks = banksMap
          .map(
            (bank) => SmartBank.fromJson(bank),
          )
          .toList();
    }

    if (page == 1) {
      preloadedBanks.clear();
    }
    preloadedBanks.addAll(banks);
    return banks;
  }

  static Future<SmartBank?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    BankRepo bankRepo = BankRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartBank? bank;
    List drawersList;
    await bankRepo.fetch(id).then((response) {
      bank = SmartBank.fromJson(response['bank']);

      try {
        drawersList = response['drawers'];
        preloadedDrawers =
            drawersList.map((drawer) => SmartDrawer.fromJson(drawer)).toList();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });

    // SmartDrawer drawer = await drawerRepo
    //     .fetch(id)
    //     .then((response) => SmartDrawer.fromJson(response['drawer']));

    return bank;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    BankRepo bankRepo = BankRepo();
    var response = await bankRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    BankRepo bankRepo = BankRepo();

    var response = await bankRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
