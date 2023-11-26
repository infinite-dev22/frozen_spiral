import 'package:flutter/foundation.dart';
import 'package:smart_case/models/smart_drawer.dart';

import '../../../data/global_data.dart';
import '../../../database/requisition/requisition_model.dart';
import '../../../database/requisition/requisition_repo.dart';

class RequisitionApi {
  static Future<List<SmartRequisition>> fetchAll(
      {int page = 1, Function()? onSuccess, Function? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    List<SmartRequisition> requisitions = List.empty(growable: true);

    var response = await requisitionRepo.fetchAll(page: page);
    List requisitionsMap = response['data'];
    requisitionNextPage = response["next_page_url"];

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
    preloadedRequisitions = requisitions;
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
    RequisitionRepo requisitionRepo = RequisitionRepo();
    var response = await requisitionRepo.post(data, id);
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    // List<SmartRequisition> requisitions = List.empty(growable: true);

    var response = await requisitionRepo.put(data, id);
    // List requisitionsMap = response['search']['requisitions'];
    //
    // if (requisitionsMap.isNotEmpty) {
    //   requisitions = requisitionsMap
    //       .map(
    //         (requisition) => SmartRequisition.fromJson(requisition),
    //       )
    //       .toList();
    // }
    //
    // preloadedRequisitions = requisitions;
    return response;
  }
}
