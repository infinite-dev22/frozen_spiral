import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/database/requisition/requisition_repo.dart';

class RequisitionApi {
  static Future<List<SmartRequisition>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    List<SmartRequisition> requisitions = List.empty(growable: true);

    var response = await requisitionRepo.fetchAll(page: page);
    List requisitionsMap = response['data'];
    requisitionNextPage = response["next_page_url"];
    List pagesList = response["links"];
    pagesLength = pagesList.length;

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartRequisition.fromJson(requisition),
          )
          .toList();
    }

    if (page == 1) {
      preloadedRequisitions.clear();
    }
    preloadedRequisitions.addAll(requisitions);
    return requisitions;
  }

  static Future<SmartRequisition?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartRequisition? requisition;
    List drawersList;
    await requisitionRepo.fetch(id).then((response) {
      requisition = SmartRequisition.fromJson(response['requisition']);

      try {
        drawersList = response['drawers'];
        preloadedDrawers =
            drawersList.map((drawer) => SmartDrawer.fromJson(drawer)).toList();
        if (onSuccess != null) onSuccess;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        if (onError != null) onError();
      }
    }).onError((error, stackTrace) => (onError != null) ? onError() : null);

    // SmartDrawer drawer = await drawerRepo
    //     .fetch(id)
    //     .then((response) => SmartDrawer.fromJson(response['drawer']));

    return requisition;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    var response = await requisitionRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static Future process(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    var response = await requisitionRepo
        .process(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();

    var response = await requisitionRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
