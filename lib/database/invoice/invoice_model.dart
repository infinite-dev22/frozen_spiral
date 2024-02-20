import 'dart:convert';

import 'package:smart_case/database/bank/bank_model.dart';
import 'package:smart_case/database/client/client_model.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/database/invoice/invoice_type_model.dart';
import 'package:smart_case/util/smart_case_init.dart';

class SmartInvoice {
  final int? id;
  final String? number;
  final dynamic date;
  final dynamic dueDate;
  final String? billTo;
  final String? invoiceDetailsTitle;
  final String? paymentTerms;
  final int? printCaseFile;
  final int? supervisorId;
  final int? currencyId;
  final dynamic letterheadId;
  final dynamic signatureId;
  final int? doneBy;
  final int? practiceAreasId;
  final int? invoiceStatusId;
  final int? invoiceTypeId;
  final int? bankId;
  final int? clientId;
  final bool? canApprove;
  final dynamic secondApprover;
  final bool? canEdit;
  final bool? isMine;
  final bool? canPay;
  final String? clientAddress;
  final int? fileId;
  final SmartFile? file;
  final int? employeeId;
  final SmartEmployee? employee;
  final SmartEmployee? approver;
  final List<String>? casePaymentTypeIds;
  final String? amount;
  final String? balance;
  final String? totalPaid;
  final List<String>? amounts;
  final List<String>? taxIds;
  final List<String>? descriptions;
  final String? invoiceStatus;
  final SmartInvoiceStatus? invoiceStatus2;
  final SmartFile? caseFile;
  final SmartClient? client;
  final SmartCurrency? currency;
  final List<dynamic>? casePayments;
  final SmartBank? bank;
  final SmartInvoiceType? invoiceType;
  final List<InvoiceFormItem>? invoiceItems;

  SmartInvoice({
    this.id,
    this.number,
    this.date,
    this.dueDate,
    this.billTo,
    this.invoiceDetailsTitle,
    this.paymentTerms,
    this.printCaseFile,
    this.supervisorId,
    this.currencyId,
    this.letterheadId,
    this.signatureId,
    this.doneBy,
    this.practiceAreasId,
    this.invoiceStatusId,
    this.invoiceTypeId,
    this.bankId,
    this.clientId,
    this.canApprove,
    this.secondApprover,
    this.canEdit,
    this.isMine,
    this.canPay,
    this.clientAddress,
    this.fileId,
    this.file,
    this.employeeId,
    this.employee,
    this.approver,
    this.casePaymentTypeIds,
    this.amount,
    this.balance,
    this.totalPaid,
    this.amounts,
    this.taxIds,
    this.descriptions,
    this.caseFile,
    this.invoiceStatus,
    this.invoiceStatus2,
    this.client,
    this.currency,
    this.casePayments,
    this.bank,
    this.invoiceType,
    this.invoiceItems,
  });

  factory SmartInvoice.fromRawJson(String str) =>
      SmartInvoice.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SmartInvoice.fromJson(Map<String, dynamic> json) => SmartInvoice(
        id: json["id"],
        number: json["number"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
        billTo: json["bill_to"],
        invoiceDetailsTitle: json["invoice_details_title"],
        paymentTerms: json["payment_terms"],
        printCaseFile: json["print_case_file"],
        supervisorId: json["supervisor_id"],
        currencyId: json["currency_id"],
        letterheadId: json["letterhead_id"],
        signatureId: json["signature_id"],
        doneBy: json["done_by"]["id"],
        practiceAreasId: json["practice_areas_id"],
        invoiceStatusId: json["invoice_status_id"],
        invoiceTypeId: json["invoice_type_id"],
        bankId: json["bank_id"],
        canApprove: json['canApprove'],
        secondApprover: json['secondApprover'],
        employee: json["done_by"] == null
            ? null
            : SmartEmployee.fromJson(json["done_by"] as Map<String, dynamic>),
        approver: json["supervisor"] == null
            ? null
            : SmartEmployee.fromJson(
                json["supervisor"] as Map<String, dynamic>),
        canEdit: json['canEdit'],
        isMine: json['isMine'],
        canPay: json['canPay'],
        clientId: json["client_id"],
        clientAddress: json["clientAddress"],
        fileId: json["file_id"],
        invoiceStatus: json["invoiceStatus"],
        invoiceStatus2: json["invoice_status"] == null
            ? null
            : SmartInvoiceStatus.fromJson(
                json["invoice_status"] as Map<String, dynamic>),
        file: json["file"] == null
            ? null
            : SmartFile.fromJson(json["file"] as Map<String, dynamic>),
        employeeId: json["employee_id"],
        casePaymentTypeIds: json["case_payment_type_ids"] == null
            ? []
            : List<String>.from(json["case_payment_type_ids"]!.map((x) => x)),
        amount: json["amount"],
        balance: json["balance"],
        totalPaid: json["totalPaid"],
        amounts: json["amounts"] == null
            ? []
            : List<String>.from(json["amounts"]!.map((x) => x)),
        taxIds: json["tax_ids"] == null
            ? []
            : List<String>.from(json["tax_ids"]!.map((x) => x)),
        descriptions: json["descriptions"] == null
            ? []
            : List<String>.from(json["descriptions"]!.map((x) => x)),
        caseFile: json["case_file"] == null
            ? null
            : SmartFile.fromJson(json["case_file"]),
        client: json["client"] == null
            ? null
            : SmartClient.fromJson(json["client"]),
        currency: json["currency"] == null
            ? null
            : SmartCurrency.fromJson(json["currency"]),
        casePayments: json["case_payments"] == null
            ? []
            : List<dynamic>.from(json["case_payments"]!.map((x) => x)),
        bank: json["bank"] == null ? null : SmartBank.fromJson(json["bank"]),
        invoiceType: json["invoice_type"] == null
            ? null
            : SmartInvoiceType.fromJson(json["invoice_type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "date": date?.toIso8601String(),
        "due_date": dueDate?.toIso8601String(),
        "bill_to": billTo,
        "invoice_details_title": invoiceType!.name,
        "payment_terms": paymentTerms,
        "print_case_file": printCaseFile,
        "supervisor_id": supervisorId,
        "currency_id": currencyId,
        "letterhead_id": letterheadId,
        "signature_id": signatureId,
        "done_by": currentUser.id,
        "practice_areas_id": practiceAreasId,
        "invoice_status_id": invoiceStatusId,
        "invoice_type_id": invoiceTypeId,
        "bank_id": bankId,
        "client_id": clientId,
        'canApprove': canApprove,
        'canEdit': canEdit,
        'isMine': isMine,
        'canPay': canPay,
        "clientAddress": clientAddress,
        "file_id": fileId,
        "employee_id": currentUser.id,
        "case_payment_type_ids": invoiceItems
            ?.map((invoiceItem) => invoiceItem.taxType!.id)
            .toList(growable: true),
        "amount": amount,
        "amounts": invoiceItems
            ?.map((invoiceItem) => invoiceItem.amount)
            .toList(growable: true),
        "tax_ids": invoiceItems == null
            ? []
            : List<dynamic>.from(invoiceItems!
                .map((invoiceItem) => invoiceItem.taxType!.code)),
        "descriptions": invoiceItems == null
            ? []
            : List<dynamic>.from(invoiceItems!
                .map((invoiceItem) => invoiceItem.description)),
        "case_file": caseFile?.toInvoiceJson(),
        "client": client?.toJson(),
        "currency": currency?.toJson(),
        "case_payments": casePayments == null
            ? []
            : List<dynamic>.from(casePayments!.map((x) => x)),
        "bank": bank?.toJson(),
        "invoice_type": invoiceType?.toJson(),
      };
}

class SmartInvoiceStatus {
  final String name;
  final String code;

  SmartInvoiceStatus({
    required this.name,
    required this.code,
  });

  factory SmartInvoiceStatus.fromJson(Map<String, dynamic> json) {
    return SmartInvoiceStatus(
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }
}
