import 'package:flutter/foundation.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_repo.dart';

class InvoiceApi {
  static Future<List<SmartInvoice>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();
    List<SmartInvoice> invoices = List.empty(growable: true);

    var response = await invoiceRepo.fetchAll();
    List invoicesMap = response['invoices'];

    if (invoicesMap.isNotEmpty) {
      invoices = invoicesMap
          .map(
            (invoice) => SmartInvoice.fromJson(invoice),
          )
          .toList();
    }
    preloadedInvoices.clear();
    preloadedInvoices.addAll(invoices);
    return invoices;
  }

  static Future<SmartInvoice?> fetch(int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();
    // DrawerRepo drawerRepo = DrawerRepo();

    SmartInvoice? invoice;
    List drawersList;
    await invoiceRepo.fetch(id).then((response) {
      invoice = SmartInvoice.fromJson(response['invoice']);
    });

    return invoice;
  }

  static Future post(Map<String, dynamic> data,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();
    var response = await invoiceRepo
        .post(data)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(Map<String, dynamic> data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();

    var response = await invoiceRepo
        .put(data, id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
