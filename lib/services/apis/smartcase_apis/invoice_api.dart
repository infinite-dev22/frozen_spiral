import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_repo.dart';

class InvoiceApi {
  static Future<List<SmartInvoice>> fetchAll(
      {Function()? onSuccess, Function? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();
    List<SmartInvoice> invoices = List.empty(growable: true);

    var response = await invoiceRepo.fetchAll();
    List invoicesMap = response;

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

    SmartInvoice? invoice;
    await invoiceRepo.fetch(id).then((response) {
      invoice = SmartInvoice.fromJsonToShow(response);
    });

    return invoice;
  }

  static Future post(SmartInvoice data,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();
    var response = await invoiceRepo
        .post(data)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => {onError!(), print(error), print(stackTrace),});
    return response;
  }

  static process(SmartInvoice data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();

    var response = await invoiceRepo
        .process(data.toJson(), id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }

  static put(SmartInvoice data, int id,
      {Function()? onSuccess, Function()? onError}) async {
    InvoiceRepo invoiceRepo = InvoiceRepo();

    var response = await invoiceRepo
        .put(data.toJson(), id)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onError!());
    return response;
  }
}
