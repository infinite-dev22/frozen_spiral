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
  final String date;
  final List<String> amounts;
  final String payoutAmount;
  final List<String> descriptions;
  final int employeeId;
  final int supervisorId;
  final int requisitionStatusId;
  final int requisitionCategoryId;
  final List<String> requisitionCategoryIds;
  final List<String> caseFileIds;
  final int currencyId;

  SmartRequisition({
    required this.date,
    required this.amounts,
    required this.payoutAmount,
    required this.descriptions,
    required this.employeeId,
    required this.supervisorId,
    required this.requisitionStatusId,
    required this.requisitionCategoryId,
    required this.requisitionCategoryIds,
    required this.caseFileIds,
    required this.currencyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
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
    };
  }

  factory SmartRequisition.fromJson(Map<String, dynamic> map) {
    return SmartRequisition(
      date: map['date'],
      amounts: map['amounts'],
      payoutAmount: map['payout_amount'],
      descriptions: map['descriptions'],
      employeeId: map['employee_id'],
      supervisorId: map['supervisor_id'],
      requisitionStatusId: map['requisition_status_id'],
      requisitionCategoryId: map['requisition_category_id'],
      requisitionCategoryIds: map['requisition_category_ids'],
      caseFileIds: map['case_file_ids'],
      currencyId: map['currency_id'],
    );
  }
}

// HIGHLY EXTENSIBLE CODE BELOW.
class Requisition {
  final int id;
  final DateTime date;
  final String amount;
  final String? description;
  final String number;
  final String? canApprove;
  final bool canEdit;
  final bool isMine;
  final bool? canPay;
  final Employee employee;
  final Employee supervisor;
  final CaseFile caseFile;
  final String requisitionCategory;
  final String currency;
  final RequisitionStatus requisitionStatus;
  final dynamic requisitionWorkflow;

  Requisition({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.number,
    required this.canApprove,
    required this.canEdit,
    required this.isMine,
    this.canPay,
    required this.employee,
    required this.supervisor,
    required this.caseFile,
    required this.requisitionCategory,
    required this.currency,
    required this.requisitionStatus,
    required this.requisitionWorkflow,
  });

  factory Requisition.fromJson(Map<String, dynamic> json) {
    return Requisition(
      id: json['id'] as int,
      date: DateTime.parse(json['date']),
      amount: json['amount'],
      description: json['description'] as String,
      number: json['number'] as String,
      canApprove: json['canApprove'] as String,
      canEdit: json['canEdit'] as bool,
      isMine: json['isMine'] as bool,
      canPay: json['canPay'],
      employee: Employee.fromJson(json['employee']),
      supervisor: Employee.fromJson(json['supervisor']),
      caseFile: CaseFile.fromJson(json['case_file']),
      requisitionCategory: json['requisition_category'] as String,
      currency: json['currency'] as String,
      requisitionStatus: RequisitionStatus.fromJson(json['requisition_status']),
      requisitionWorkflow: json['requisition_workflow'],
    );
  }
}

class Employee {
  final String firstName;
  final String lastName;

  Employee({
    required this.firstName,
    required this.lastName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}

class CaseFile {
  final int id;
  final String fileName;
  final String fileNumber;
  final String? courtFileNumber;

  CaseFile({
    required this.id,
    required this.fileName,
    required this.fileNumber,
    required this.courtFileNumber,
  });

  factory CaseFile.fromJson(Map<String, dynamic> json) {
    return CaseFile(
      id: json['id'] as int,
      fileName: json['file_name'] as String,
      fileNumber: json['file_number'] as String,
      courtFileNumber: json['court_file_number'] as String,
    );
  }
}

class RequisitionStatus {
  final String name;
  final String code;

  RequisitionStatus({
    required this.name,
    required this.code,
  });

  factory RequisitionStatus.fromJson(Map<String, dynamic> json) {
    return RequisitionStatus(
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }
}
