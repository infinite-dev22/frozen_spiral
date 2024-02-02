import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/database/invoice/invoice_type_repo.dart';

class InvoiceTypeApi {
  static Future<List<SmartInvoiceType>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    InvoiceTypeRepo invoiceTypeRepo = InvoiceTypeRepo();
    List<SmartInvoiceType> invoiceTypes = List.empty(growable: true);

    var response = await invoiceTypeRepo.fetchAll();
    List invoiceTypesMap = response;

    if (invoiceTypesMap.isNotEmpty) {
      invoiceTypes = invoiceTypesMap
          .map(
            (invoiceType) => SmartInvoiceType.fromJson(invoiceType),
          )
          .toList();
    }

    preloadedInvoiceTypes.clear();
    preloadedInvoiceTypes.addAll(invoiceTypes);
    return invoiceTypes;
  }

  static Future<SmartInvoiceType?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceTypeRepo invoiceTypeRepo = InvoiceTypeRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartInvoiceType? invoiceType;

    // SmartDrawer drawer = await drawerRepo
    //     .fetch(id)
    //     .then((response) => SmartDrawer.fromJson(response['drawer']));

    return invoiceType;
  }

  static Future post(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceTypeRepo invoiceTypeRepo = InvoiceTypeRepo();
    var response = await invoiceTypeRepo
        .post(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceTypeRepo invoiceTypeRepo = InvoiceTypeRepo();

    var response = await invoiceTypeRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
