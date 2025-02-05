import 'dart:convert';

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
  String? swiftCode;
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
    this.swiftCode,
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
      swiftCode: json['swift_code'],
      description: json['description'],
    );
  }

  factory SmartBank.fromRawJson(String str) =>
      SmartBank.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "account_number": accountNumber,
        "account_name": accountName,
        "swift_code": swiftCode,
        "branch": branch,
      };

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return name!;
  }
}
