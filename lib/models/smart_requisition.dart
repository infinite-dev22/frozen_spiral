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