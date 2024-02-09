import 'package:smart_case/database/invoice/invoice_item_model.dart';
import 'package:smart_case/database/smart_model.dart';
import 'package:smart_case/database/tax/tax_type_model.dart';

class InvoiceFormItem extends SmartModel {
  final int? id;
  final SmartInvoiceItem? item;
  final String? description;
  final double? amount;
  final SmartTaxType? taxType;
  final double? totalAmount;
  final double? taxableAmount;

  InvoiceFormItem({
    this.id,
    this.item,
    this.description,
    this.amount,
    this.taxType,
    this.totalAmount,
    this.taxableAmount,
  });

  factory InvoiceFormItem.fromJson(Map<String, dynamic> json) =>
      InvoiceFormItem(
        id: json['id'] as int?,
        item: json['item'] == null
            ? null
            : SmartInvoiceItem.fromJson(json['item'] as Map<String, dynamic>),
        description: json['description'] as String?,
        amount: (json['amount'] as num?)?.toDouble(),
        taxType: json['taxType'] == null
            ? null
            : SmartTaxType.fromJson(json['taxType'] as Map<String, dynamic>),
        totalAmount: (json['totalAmount'] as num?)?.toDouble(),
        taxableAmount: (json['taxableAmount'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toJson(InvoiceFormItem instance) => <String, dynamic>{
        'id': instance.id,
        'item': instance.item,
        'description': instance.description,
        'amount': instance.amount,
        'taxType': instance.taxType,
        'totalAmount': instance.totalAmount,
        'taxableAmount': instance.taxableAmount,
      };

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
