import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_file.dart';
import 'package:smart_case/models/smart_model.dart';

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
  final bool? canEdit;
  final bool? isMine;
  final bool? canPay;
  final List<String>? amounts;
  final String? payoutAmount;
  final List<String>? descriptions;
  final int? employeeId;
  final int? supervisorId;
  final int? requisitionStatusId;
  final int? requisitionCategoryId;
  final List<String>? requisitionCategoryIds;
  final List<String>? caseFileIds;
  final int? currencyId;
  final SmartEmployee? employee;
  final SmartEmployee? supervisor;
  final SmartFile? caseFile;
  final String? requisitionCategory;
  final String? currency;
  final SmartRequisitionStatus? requisitionStatus;
  final dynamic requisitionWorkflow;

  SmartRequisition({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.number,
    this.canApprove,
    this.canEdit,
    this.isMine,
    this.canPay,
    this.amounts,
    this.payoutAmount,
    this.descriptions,
    this.employeeId,
    this.supervisorId,
    this.requisitionStatusId,
    this.requisitionCategoryId,
    this.requisitionCategoryIds,
    this.caseFileIds,
    this.currencyId,
    this.employee,
    this.supervisor,
    this.caseFile,
    this.requisitionCategory,
    this.currency,
    this.requisitionStatus,
    this.requisitionWorkflow,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
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
      'requisition_category_ids': requisitionCategoryIds,
      'case_file_ids': caseFileIds,
      'currency_id': currencyId,
      'employee': employee,
      'supervisor': supervisor,
      'case_file': caseFile,
      'requisition_category': requisitionCategory,
      'currency': currency,
      'requisition_status': requisitionStatus,
      'requisition_workflow': requisitionWorkflow,
    };
  }

  factory SmartRequisition.fromJson(Map<String, dynamic> json) {
    return SmartRequisition(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      description: json['description'] as String,
      number: json['number'] as String,
      canApprove: json['canApprove'] as String,
      canEdit: json['canEdit'] as bool,
      isMine: json['isMine'] as bool,
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
      requisitionCategory: json['requisition_category'] as String,
      currency: json['currency'] as String,
      requisitionStatus:
          SmartRequisitionStatus.fromJson(json['requisition_status']),
      requisitionWorkflow: json['requisition_workflow'],
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
