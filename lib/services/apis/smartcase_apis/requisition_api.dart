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

  static fetch({Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    List<SmartRequisition> requisitions = List.empty(growable: true);

    Map response = await requisitionRepo.fetchAll();
    List requisitionsMap = response['search']['requisitions'];

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartRequisition.fromJson(requisition),
          )
          .toList();
    }

    preloadedRequisitions = requisitions;
  }

  static post({Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    List<SmartRequisition> requisitions = List.empty(growable: true);

    Map response = await requisitionRepo.fetchAll();
    List requisitionsMap = response['search']['requisitions'];

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartRequisition.fromJson(requisition),
          )
          .toList();
    }

    preloadedRequisitions = requisitions;
  }

  static put({Function()? onSuccess, Function()? onError}) async {
    RequisitionRepo requisitionRepo = RequisitionRepo();
    List<SmartRequisition> requisitions = List.empty(growable: true);

    Map response = await requisitionRepo.fetchAll();
    List requisitionsMap = response['search']['requisitions'];

    if (requisitionsMap.isNotEmpty) {
      requisitions = requisitionsMap
          .map(
            (requisition) => SmartRequisition.fromJson(requisition),
          )
          .toList();
    }

    preloadedRequisitions = requisitions;
  }
}
