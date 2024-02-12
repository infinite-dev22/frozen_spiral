// import 'dart:convert';
//
// import 'package:smart_case/database/bank/bank_model.dart';
// import 'package:smart_case/database/currency/smart_currency.dart';
// import 'package:smart_case/database/employee/employee_model.dart';
// import 'package:smart_case/database/file/file_model.dart';
// import 'package:smart_case/database/invoice/invoice_form_item.dart';
// import 'package:smart_case/database/invoice/invoice_type_model.dart';
// import 'package:smart_case/util/smart_case_init.dart';
//
// SmartInvoice smartInvoiceFromJson(String str) =>
//     SmartInvoice.fromJson(json.decode(str));
//
// String smartInvoiceToJson(SmartInvoice data) => json.encode(data.toJson());
//
// class SmartInvoice {
//   final int? id;
//   final dynamic invoiceTypeId;
//   final SmartInvoiceType? invoiceType;
//   final dynamic date;
//   final SmartFile? file;
//   final dynamic fileId;
//   final dynamic clientId;
//   final dynamic clientAddress;
//   final SmartCurrency? currency;
//   final dynamic currencyId;
//   final List<InvoiceFormItem>? invoiceItems;
//   final dynamic totalSubAmount;
//   final dynamic totalAmount;
//   final dynamic totalTaxableAmount;
//   final SmartBank? bank;
//   final dynamic bankId;
//   final dynamic bankDetails;
//   final SmartEmployee? approver;
//   final dynamic approverId;
//   final dynamic invoiceTerms;
//   String? dueDate;
//   String? billTo;
//   int? doneBy;
//   int? employeeId;
//   int? practiceAreasId;
//   int? caseFileId;
//   int? supervisorId;
//   int? invoiceStatusId;
//   String? paymentTerms;
//   List<String>? casePaymentTypeIds;
//   List<String>? amounts;
//   String? invoiceDetailsTitle;
//   List<String>? taxIds;
//   List<String>? descriptions;
//
//   SmartInvoice({
//     this.id,
//     this.invoiceType,
//     this.file,
//     this.fileId,
//     this.clientAddress,
//     this.currency,
//     this.invoiceItems,
//     this.totalSubAmount,
//     this.totalAmount,
//     this.totalTaxableAmount,
//     this.bank,
//     this.bankDetails,
//     this.approver,
//     this.approverId,
//     this.invoiceTerms,
//     this.date,
//     this.dueDate,
//     this.billTo,
//     this.currencyId,
//     this.clientId,
//     this.doneBy,
//     this.employeeId,
//     this.practiceAreasId,
//     this.caseFileId,
//     this.supervisorId,
//     this.invoiceTypeId,
//     this.bankId,
//     this.invoiceStatusId,
//     this.paymentTerms,
//     this.casePaymentTypeIds,
//     this.amounts,
//     this.invoiceDetailsTitle,
//     this.taxIds,
//     this.descriptions,
//   });
//
//   factory SmartInvoice.fromJson(Map<String, dynamic> json) => SmartInvoice(
//         date: json["date"],
//         dueDate: json["due_date"],
//         billTo: json["bill_to"],
//         currencyId: json["currency_id"],
//         clientId: json["client_id"],
//         doneBy: json["done_by"],
//         employeeId: json["employee_id"],
//         practiceAreasId: json["practice_areas_id"],
//         caseFileId: json["case_file_id"],
//         supervisorId: json["supervisor_id"],
//         invoiceTypeId: json["invoice_type_id"],
//         bankId: json["bank_id"],
//         invoiceStatusId: json["invoice_status_id"],
//         paymentTerms: json["payment_terms"],
//         casePaymentTypeIds: json["case_payment_type_ids"] == null
//             ? []
//             : List<String>.from(json["case_payment_type_ids"]!.map((x) => x)),
//         amounts: json["amounts"] == null
//             ? []
//             : List<String>.from(json["amounts"]!.map((x) => x)),
//         invoiceDetailsTitle: json["invoice_details_title"],
//         taxIds: json["tax_ids"] == null
//             ? []
//             : List<String>.from(json["tax_ids"]!.map((x) => x)),
//         descriptions: json["descriptions"] == null
//             ? []
//             : List<String>.from(json["descriptions"]!.map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "date": date,
//         "due_date": dueDate,
//         "bill_to": billTo,
//         "currency_id": currencyId,
//         "client_id": clientId,
//         "done_by": currentUser.id,
//         "employee_id": currentUser.id,
//         "case_file_id": this.fileId,
//         "supervisor_id": this.approverId,
//         "invoice_type_id": invoiceTypeId,
//         "bank_id": bankId,
//         "payment_terms": paymentTerms,
//         "case_payment_type_ids": this.invoiceItems == null
//             ? []
//             : List<dynamic>.from(this.invoiceItems!.map((x) => x.id)),
//         "amounts": this.invoiceItems == null
//             ? []
//             : List<dynamic>.from(this.invoiceItems!.map((x) => x.amount)),
//         "invoice_details_title": this.invoiceType!.name,
//         "tax_ids": this.invoiceItems == null
//             ? []
//             : List<dynamic>.from(
//                 this.invoiceItems!.map((x) => x.taxType!.code)),
//         "descriptions": this.invoiceItems == null
//             ? []
//             : List<dynamic>.from(this.invoiceItems!.map((x) => x.description)),
//       };
// }

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
  final dynamic dueDate;
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
    this.dueDate,
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
        dueDate: json['dueDate'] == null
            ? null
            : DateTime.parse(json['dueDate'] as String),
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
        'due_date': this.dueDate,
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
        'case_payment_type_ids': this
            .invoiceItems
            ?.map((invoiceItem) => invoiceItem.taxType!.id)
            .toList(growable: true),
        'amounts': this
            .invoiceItems
            ?.map((invoiceItem) => invoiceItem.amount)
            .toList(growable: true),
        'invoice_details_title': this.invoiceType!.name,
        "tax_ids": this.invoiceItems == null
            ? []
            : List<dynamic>.from(this
                .invoiceItems!
                .map((invoiceItem) => invoiceItem.taxType!.code)),
        "descriptions": this.invoiceItems == null
            ? []
            : List<dynamic>.from(this
                .invoiceItems!
                .map((invoiceItem) => invoiceItem.description)),
      };
}
