import 'package:smart_case/database/smart_model.dart';

class SmartTaxType extends SmartModel {
  int? id;
  String? code;
  String? name;
  String? description;
  String? rate;
  int? active;
  int? isActive;

  SmartTaxType({
    this.id,
    this.code,
    this.name,
    this.description,
    this.rate,
    this.active,
    this.isActive,
  });

  factory SmartTaxType.fromJson(Map<String, dynamic> json) {
    return SmartTaxType(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      rate: json['rate'],
      active: json['active'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'rate': rate,
      'active': active,
      'is_active': isActive,
    };
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
