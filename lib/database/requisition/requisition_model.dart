import 'package:intl/intl.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/smart_model.dart';
import 'package:smart_case/util/utilities.dart';

class SmartRequisitionCategory extends SmartModel {
  final int id;
  final String name;

  SmartRequisitionCategory({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory SmartRequisitionCategory.fromJson(Map<String, dynamic> doc) {
    return SmartRequisitionCategory(
      id: doc['id'],
      name: doc['name'],
    );
  }

  @override
  int getId() {
    return id;
  }

  @override
  String getName() {
    return name;
  }
}

class SmartRequisition {
  final int? id;
  final DateTime? date;
  final String? amount;
  final String? description;
  final String? number;
  final String? canApprove;
  final dynamic secondApprover;
  final bool? canEdit;
  final bool? isMine;
  final bool? canPay;
  final List<String>? amounts;
  final String? payoutAmount;
  final String? flowType;
  final List<String>? descriptions;
  final int? employeeId;
  final int? supervisorId;
  final int? requisitionStatusId;
  final int? requisitionCategoryId;
  final int? caseFileId;
  final List<String>? requisitionCategoryIds;
  final List<String>? caseFileIds;
  final int? currencyId;
  final SmartEmployee? employee;
  final SmartEmployee? supervisor;
  final SmartFile? caseFile;
  final String? requisitionCategoryName;
  final SmartCurrency? currency;
  final SmartRequisitionStatus? requisitionStatus;
  final SmartRequisitionCategory? requisitionCategory;
  final String? caseFinancialStatus;

  SmartRequisition({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.number,
    this.canApprove,
    this.secondApprover,
    this.canEdit,
    this.isMine,
    this.canPay,
    this.amounts,
    this.payoutAmount,
    this.flowType,
    this.descriptions,
    this.employeeId,
    this.supervisorId,
    this.requisitionStatusId,
    this.requisitionCategoryId,
    this.caseFileId,
    this.requisitionCategoryIds,
    this.caseFileIds,
    this.currencyId,
    this.employee,
    this.supervisor,
    this.caseFile,
    this.requisitionCategoryName,
    this.currency,
    this.requisitionStatus,
    this.requisitionCategory,
    this.caseFinancialStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'amount': amount,
      'description': description,
      'number': number,
      'canApprove': canApprove,
      'canEdit': canEdit,
      'isMine': isMine,
      'canPay': canPay,
      'amounts': amounts,
      'payout_amount': payoutAmount,
      'descriptions': descriptions,
      'employee_id': employeeId,
      'supervisor_id': supervisorId,
      'requisition_status_id': requisitionStatusId,
      'requisition_category_id': requisitionCategoryId,
      'case_file_id': caseFileId,
      'requisition_category_ids': requisitionCategoryIds,
      'case_file_ids': caseFileIds,
      'currency_id': currencyId,
      'employee': employee,
      'supervisor': supervisor,
      'case_file': caseFile,
      'requisition_category': requisitionCategoryName,
      'currency': currency,
      'requisition_status': requisitionStatus,
      // 'requisition_category': requisitionCategory,
      'caseFinancialStatus': caseFinancialStatus,
    };
  }

  // Convert the requisition class to a json object.
  Map<String, dynamic> createRequisitionToJson() {
    return {
      'date': DateFormat('dd/MM/yyyy').format(date!),
      'amount': amount,
      'amounts': amounts,
      'payout_amount': payoutAmount,
      'description': description,
      'descriptions': descriptions,
      'employee_id': employeeId,
      'supervisor_id': supervisorId,
      'requisition_status_id': requisitionStatusId,
      'requisition_category_id': requisitionCategoryId,
      'case_file_id': caseFileId,
      'requisition_category_ids': requisitionCategoryIds,
      'case_file_ids': caseFileIds,
      'currency_id': currencyId,
    };
  }

  factory SmartRequisition.fromJson(Map<String, dynamic> json) {
    return SmartRequisition(
      id: json['id'] as int,
      date: formatDateTimeString(json['date']),
      flowType: json["flowtypetwo"],
      amount: json['payout_amount'],
      description: json['description'],
      number: json['number'],
      canApprove: json['canApprove'],
      secondApprover: json['secondApprover'],
      canEdit: json['canEdit'],
      isMine: json['isMine'],
      canPay: json['canPay'],
      amounts: json['amounts'],
      payoutAmount: json['payout_amount'],
      descriptions: json['descriptions'],
      employeeId: json['employee_id'],
      supervisorId: json['supervisor_id'],
      requisitionStatusId: json['requisition_status_id'],
      requisitionCategoryId: json['requisition_category_id'],
      requisitionCategoryIds: json['requisition_category_ids'],
      caseFileIds: json['case_file_ids'],
      currencyId: json['currency_id'],
      employee: SmartEmployee.fromJson(json['employee']),
      supervisor: SmartEmployee.fromJson(json['supervisor']),
      caseFile: SmartFile.fromJson(json['case_file']),
      requisitionCategoryName: json['requisition_category']['name'],
      currency: SmartCurrency.fromJson(json['currency']),
      requisitionStatus: SmartRequisitionStatus.fromJson(
          json['requisition_actions'].last['requisition_status']),
      requisitionCategory:
          SmartRequisitionCategory.fromJson(json['requisition_category']),
      caseFinancialStatus: json['caseFinancialStatusDisp'],
    );
  }

  factory SmartRequisition.fromJsonToView(Map<String, dynamic> json) {
    return SmartRequisition(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      description: json['description'],
      number: json['number'],
      canApprove: json['canApprove'],
      canEdit: json['canEdit'],
      isMine: json['isMine'],
      canPay: json['canPay'],
      amounts: json['amounts'],
      payoutAmount: json['payout_amount'],
      descriptions: json['descriptions'],
      employeeId: json['employee_id'],
      supervisorId: json['supervisor_id'],
      requisitionStatusId: json['requisition_status_id'],
      requisitionCategoryId: json['requisition_category_id'],
      requisitionCategory:
          SmartRequisitionCategory.fromJson(json['requisition_category']),
      requisitionCategoryIds: json['requisition_category_ids'],
      caseFileIds: json['case_file_ids'],
      currencyId: json['currency_id'],
      employee: SmartEmployee.fromJson(json['employee']),
      supervisor: SmartEmployee.fromJson(json['supervisor']),
      caseFile: SmartFile.fromJson(json['case_file']),
      currency: SmartCurrency.fromJson(json['currency']),
      requisitionStatus:
          SmartRequisitionStatus.fromJson(json['requisition_status']),
      caseFinancialStatus: json['caseFinancialStatusDisp'],
    );
  }
}

class SmartRequisitionStatus {
  final String name;
  final String code;

  SmartRequisitionStatus({
    required this.name,
    required this.code,
  });

  factory SmartRequisitionStatus.fromJson(Map<String, dynamic> json) {
    return SmartRequisitionStatus(
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }
}
