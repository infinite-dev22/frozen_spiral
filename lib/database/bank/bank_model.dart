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
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

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
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
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
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
