import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/invoice/invoice_approvers_repo.dart';

class InvoiceApproverApi {
  static Future<List<SmartEmployee>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    InvoiceApproverRepo requisitionRepo = InvoiceApproverRepo();
    List<SmartEmployee> requisitions = List.empty(growable: true);

    var response = await requisitionRepo.fetchAll(page: page);
    List requisitionsMap = response['employees'];

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartEmployee.fromJson(requisition),
          )
          .toList();
    }

    if (page == 1) {
      preloadedInvoiceApprovers.clear();
    }
    preloadedInvoiceApprovers.addAll(requisitions);
    return requisitions;
  }

  static Future<SmartEmployee?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceApproverRepo requisitionRepo = InvoiceApproverRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartEmployee? requisition;
    List drawersList;
    await requisitionRepo.fetch(id).then((response) {
      requisition = SmartEmployee.fromJson(response['requisition']);

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
    InvoiceApproverRepo requisitionRepo = InvoiceApproverRepo();
    var response = await requisitionRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceApproverRepo requisitionRepo = InvoiceApproverRepo();

    var response = await requisitionRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
