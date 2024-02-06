import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';
import 'package:smart_case/database/tax/tax_type_repo.dart';

class TaxTypeApi {
  static Future<List<SmartTaxType>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    TaxTypeRepo taxTypeRepo = TaxTypeRepo();
    List<SmartTaxType> taxTypes = List.empty(growable: true);

    var response = await taxTypeRepo.fetchAll();
    List taxTypesMap = response["taxes"]['data'];

    if (taxTypesMap.isNotEmpty) {
      taxTypes = taxTypesMap
          .map(
            (taxType) => SmartTaxType.fromJson(taxType),
          )
          .toList();
    }

    if (page == 1) {
      preloadedTaxTypes.clear();
    }
    preloadedTaxTypes.addAll(taxTypes);
    return taxTypes;
  }

  static Future<SmartTaxType?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaxTypeRepo taxTypeRepo = TaxTypeRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartTaxType? taxType;
    List drawersList;
    await taxTypeRepo.fetch(id).then((response) {
      taxType = SmartTaxType.fromJson(response['taxType']);

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

    return taxType;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaxTypeRepo taxTypeRepo = TaxTypeRepo();
    var response = await taxTypeRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    TaxTypeRepo taxTypeRepo = TaxTypeRepo();

    var response = await taxTypeRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
