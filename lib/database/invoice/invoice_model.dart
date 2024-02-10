import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/util/smart_case_init.dart';

@JsonSerializable()
class SmartInvoice {
  final int? id;
  final dynamic invoiceTypeId;
  final SmartInvoiceType? invoiceType;
  final dynamic date;
  final dynamic dueOn;
  final SmartFile? file;
  final dynamic fileId;
  final dynamic clientId;
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
    this.invoiceType,
    this.date,
    this.dueOn,
    this.file,
    this.fileId,
    this.clientId,
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
        'date': this.date,
        'due_on': this.dueOn,
        'bill_to': this.clientAddress,
        'currency_id': this.currencyId,
        'client_id': this.clientId,
        'done_by': currentUser.id,
        'employee_id': currentUser.id,
        'case_file_id': this.fileId,
        'supervisor_id': this.approverId,
        'invoice_type_id': this.invoiceTypeId,
        'bank_id': this.bankId,
        'payment_terms': this.invoiceTerms,
        'case_payment_type_id': this
            .invoiceItems
            ?.map((invoiceItem) => invoiceItem.taxType!.id)
            .toList(growable: true),
        'amounts': this
            .invoiceItems
            ?.map((invoiceItem) => invoiceItem.amount)
            .toList(growable: true),
        'invoice_details_title': this.invoiceType!.name,
        'tax_ids': this
            .invoiceItems
            ?.map((invoiceItem) => json.encode(invoiceItem.taxType!.code))
            .toList(growable: true),
        'descriptions': this
            .invoiceItems
            ?.map((invoiceItem) => json.encode(invoiceItem.description))
            .toList(growable: true),
      };
}
