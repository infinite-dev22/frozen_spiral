import 'package:smart_case/models/smart_model.dart';

class SmartRequisition {
  final String date;
  final String amount;
  final String payoutAmount;
  final String description;
  final int employeeId;
  final int supervisorId;
  final int requisitionStatusId;
  final int requisitionCategoryId;
  final int currencyId;

  SmartRequisition({
    required this.date,
    required this.amount,
    required this.payoutAmount,
    required this.description,
    required this.employeeId,
    required this.supervisorId,
    required this.requisitionStatusId,
    required this.requisitionCategoryId,
    required this.currencyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'payout_amount': payoutAmount,
      'description': description,
      'employee_id': employeeId,
      'supervisor_id': supervisorId,
      'requisition_status_id': requisitionStatusId,
      'requisition_category_id': requisitionCategoryId,
      'currency_id': currencyId,
    };
  }

  factory SmartRequisition.fromJson(Map<String, dynamic> doc) {
    return SmartRequisition(
      date: doc['date'],
      amount: doc['amount'].toString(),
      payoutAmount: doc['payout_amount'].toString(),
      description: doc['description'],
      employeeId: doc['employee_id'],
      supervisorId: doc['supervisor_id'],
      requisitionStatusId: doc['requisition_status_id'],
      requisitionCategoryId: doc['requisition_category_id'],
      currencyId: doc['currency_id'],
    );
  }
}

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
