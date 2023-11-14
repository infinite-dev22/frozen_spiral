import '../../../data/global_data.dart';
import '../../../database/requisition/requisition_model.dart';
import '../../../database/requisition/requisition_repo.dart';

class RequisitionApi {
  static Future<List<SmartRequisition>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    List<SmartRequisition> requisitions = List.empty(growable: true);

    var response = await requisitionRepo.fetchAll();
    List requisitionsMap = response['search']['requisitions'];

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartRequisition.fromJson(requisition),
          )
          .toList();
    }

    preloadedRequisitions = requisitions;
    return requisitions;
  }

  static Future<SmartRequisition> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();

    SmartRequisition requisition = await requisitionRepo
        .fetch(id)
        .then((response) => SmartRequisition.fromJson(response['requisition']));

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
