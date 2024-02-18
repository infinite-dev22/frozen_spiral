import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/invoice/invoice_approvers_repo.dart';

class InvoiceApproverApi {
  static Future<List<SmartEmployee>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    InvoiceApproverRepo invoiceApproverRepo = InvoiceApproverRepo();
    List<SmartEmployee> invoiceApprovers = List.empty(growable: true);

    var response = await invoiceApproverRepo.fetchAll();
    List invoiceApproversMap = response['employees'];

    if (invoiceApproversMap.isNotEmpty) {
      invoiceApprovers = invoiceApproversMap
          .map(
            (invoiceApprover) => SmartEmployee.fromJson(invoiceApprover),
          )
          .toList();
    }

    preloadedInvoiceApprovers.clear();
    preloadedInvoiceApprovers.addAll(invoiceApprovers);
    return invoiceApprovers;
  }

  static Future<SmartEmployee?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceApproverRepo invoiceApproverRepo = InvoiceApproverRepo();

    SmartEmployee? invoiceApprover;
    await invoiceApproverRepo.fetch(id).then((response) {
      invoiceApprover = SmartEmployee.fromJson(response['invoiceApprover']);
    });

    return invoiceApprover;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceApproverRepo invoiceApproverRepo = InvoiceApproverRepo();

    var response = await invoiceApproverRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
