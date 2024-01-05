import 'package:smart_case/database/smart_model.dart';

class SmartEmployee extends SmartModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? title;
  final String? code;
  final String? description;
  final int? isActive;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;

  SmartEmployee({
    this.id,
    this.firstName,
    this.lastName,
    this.title,
    this.code,
    this.description,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'title': title,
      'code': code,
      'description': description,
      'is_active': isActive,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory SmartEmployee.fromJson(Map<String, dynamic> json) {
    return SmartEmployee(
      id: json['id'],
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      title: json['title'],
      code: json['code'],
      description: json['description'],
      isActive: json['is_active'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return "$firstName $lastName";
  }
}
