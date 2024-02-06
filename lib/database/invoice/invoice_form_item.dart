import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/smart_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';

class InvoiceFormItem extends SmartModel {
  final int? id;
  final SmartInvoiceItem? item;
  final String? description;
  final String? amount;
  final SmartTaxType? taxType;
  final String? totalAmount;

  InvoiceFormItem({
    this.id,
    this.item,
    this.description,
    this.amount,
    this.taxType,
    this.totalAmount,
  });

  @override
  int getId() {
    return this.id!;
  }

  @override
  String getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }
}
