import 'package:smart_case/database/smart_model.dart';

class SmartBank extends SmartModel {
  int? id;
  String? code;
  String? accountNumber;
  String? accountName;
  String? branch;
  int? isPayroll;
  int? isActive;
  String? name;
  String? description;

  SmartBank({
    this.id,
    this.code,
    this.accountNumber,
    this.accountName,
    this.branch,
    this.isPayroll,
    this.isActive,
    this.name,
    this.description,
  });

  factory SmartBank.fromJson(Map<String, dynamic> json) {
    return SmartBank(
      id: json['id'],
      code: json['code'],
      accountNumber: json['account_number'],
      accountName: json['account_name'],
      branch: json['branch'],
      isPayroll: json['is_payroll'],
      isActive: json['is_active'],
      name: json['name'],
      description: json['description'],
    );
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return name!;
  }
}
