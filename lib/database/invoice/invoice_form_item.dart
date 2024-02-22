import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/smart_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';

class InvoiceFormItem extends SmartModel {
  final int? id;
  final SmartInvoiceItem? item;
  final dynamic itemId;
  final String? description;
  final double? amount;
  final SmartTaxType? taxType;
  final double? totalAmount;
  final double? taxableAmount;

  InvoiceFormItem({
    this.id,
    this.item,
    this.itemId,
    this.description,
    this.amount,
    this.taxType,
    this.totalAmount,
    this.taxableAmount,
  });

  factory InvoiceFormItem.fromJson(Map<String, dynamic> json) {
    var amnt = double.parse(json['unit_price']);
    var tax = json['tax'] == null
        ? null
        : SmartTaxType.fromJson(json['tax'] as Map<String, dynamic>);
    var subAmount = (tax == null) ? amnt : amnt * double.parse(tax!.rate!) * 100;

    return InvoiceFormItem(
      id: json['id'] as int?,
      item: json['item'] == null
          ? null
          : SmartInvoiceItem.fromJson(json['item'] as Map<String, dynamic>),
      description: json['description'] as String?,
      amount: amnt,
      taxType: json['tax'] == null
          ? null
          : SmartTaxType.fromJson(json['tax'] as Map<String, dynamic>),
      totalAmount: subAmount /*(json['totalAmount'] as num?)?.toDouble()*/,
      taxableAmount: (json['taxableAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'case_payment_type_id': item?.id,
        'description': description,
        'amount': amount,
        'tax_code': taxType!.code,
      };

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    // TODO: implement getName
    throw UnimplementedError();
  }
}
