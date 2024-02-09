import 'package:json_annotation/json_annotation.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';

@JsonSerializable()
class SmartInvoice {
  final int? id;
  final dynamic invoiceTypeId;
  final dynamic date;
  final dynamic dueOn;
  final SmartFile? file;
  final dynamic fileId;
  final dynamic clientAddress;
  final SmartCurrency? currency;
  final dynamic currencyId;
  final List<InvoiceFormItem>? invoiceItems;
  final dynamic totalSubAmount;
  final dynamic totalAmount;
  final dynamic totalTaxableAmount;
  final SmartBank? bank;
  final dynamic bankId;
  final dynamic bankDetails;
  final SmartEmployee? approver;
  final dynamic approverId;
  final dynamic invoiceTerms;

  SmartInvoice({
    this.id,
    this.invoiceTypeId,
    this.date,
    this.dueOn,
    this.file,
    this.fileId,
    this.clientAddress,
    this.currency,
    this.currencyId,
    this.invoiceItems,
    this.totalSubAmount,
    this.totalAmount,
    this.totalTaxableAmount,
    this.bank,
    this.bankId,
    this.bankDetails,
    this.approver,
    this.approverId,
    this.invoiceTerms,
  });

  // factory SmartInvoice.fromJson(Map<String, dynamic> json) =>
  //     _$SmartInvoiceFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$SmartInvoiceToJson(this);

  factory SmartInvoice.fromJson(Map<String, dynamic> json) => SmartInvoice(
        id: json['id'] as int?,
        invoiceTypeId: json['invoiceTypeId'],
        date: json['date'] == null
            ? null
            : DateTime.parse(json['date'] as String),
        dueOn: json['dueOn'] == null
            ? null
            : DateTime.parse(json['dueOn'] as String),
        file: json['file'] == null
            ? null
            : SmartFile.fromJson(json['file'] as Map<String, dynamic>),
        fileId: json['fileId'],
        clientAddress: json['clientAddress'],
        currency: json['currency'] == null
            ? null
            : SmartCurrency.fromJson(json['currency'] as Map<String, dynamic>),
        currencyId: json['currencyId'],
        invoiceItems: (json['invoiceItems'] as List<dynamic>?)
            ?.map((e) => InvoiceFormItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        totalSubAmount: json['totalSubAmount'],
        totalAmount: json['totalAmount'],
        totalTaxableAmount: json['totalTaxableAmount'],
        bank: json['bank'] == null
            ? null
            : SmartBank.fromJson(json['bank'] as Map<String, dynamic>),
        bankId: json['bankId'],
        bankDetails: json['bankDetails'],
        approver: json['approver'] == null
            ? null
            : SmartEmployee.fromJson(json['approver'] as Map<String, dynamic>),
        approverId: json['approverId'],
        invoiceTerms: json['invoiceTerms'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'invoiceTypeId': this.invoiceTypeId,
        'date': this.date,
        'dueOn': this.dueOn,
        'file': this.file,
        'fileId': this.fileId,
        'clientAddress': this.clientAddress,
        'currency': this.currency,
        'currencyId': this.currencyId,
        'invoiceItems': this.invoiceItems,
        'totalSubAmount': this.totalSubAmount,
        'totalAmount': this.totalAmount,
        'totalTaxableAmount': this.totalTaxableAmount,
        'bank': this.bank,
        'bankId': this.bankId,
        'bankDetails': this.bankDetails,
        'approver': this.approver,
        'approverId': this.approverId,
        'invoiceTerms': this.invoiceTerms,
      };
}
