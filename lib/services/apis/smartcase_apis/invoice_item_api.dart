import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/invoice/invoice_item_repo.dart';

class InvoiceItemApi {
  static Future<List<SmartInvoiceItem>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    InvoiceItemRepo requisitionRepo = InvoiceItemRepo();
    List<SmartInvoiceItem> requisitions = List.empty(growable: true);

    var response = await requisitionRepo.fetchAll();
    List requisitionsMap = response['casePaymentType'];

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartInvoiceItem.fromJson(requisition),
          )
          .toList();
    }
    preloadedInvoiceItems.clear();
    preloadedInvoiceItems.addAll(requisitions);
    return requisitions;
  }

  static Future<SmartInvoiceItem?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceItemRepo requisitionRepo = InvoiceItemRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartInvoiceItem? requisition;
    List drawersList;
    await requisitionRepo.fetch(id).then((response) {
      requisition = SmartInvoiceItem.fromJson(response['requisition']);

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

    return requisition;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceItemRepo requisitionRepo = InvoiceItemRepo();
    var response = await requisitionRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceItemRepo requisitionRepo = InvoiceItemRepo();

    var response = await requisitionRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
