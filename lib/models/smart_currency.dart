import 'package:smart_case/models/smart_model.dart';

class SmartCurrency extends SmartModel {
  final int? id;
  final String? name;
  final String? code;
  final int? isActive;
  final int? createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;

  SmartCurrency({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory SmartCurrency.fromJson(Map<String, dynamic> doc) {
    return SmartCurrency(
      id: doc['id'],
      name: doc['name'],
      code: doc['code'],
      isActive: doc['is_active'],
      createdBy: doc['created_by'],
      updatedBy: doc['updated_by'],
      createdAt: doc['created_at'],
      updatedAt: doc['updated_at'],
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
