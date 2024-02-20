import 'package:smart_case/database/smart_model.dart';

class SmartInvoiceType extends SmartModel {
  int? id;
  String? name;
  String? code;
  String? title;
  int? isActive;

  SmartInvoiceType({
    this.id,
    this.name,
    this.code,
    this.title,
    this.isActive,
  });

  factory SmartInvoiceType.fromJson(Map<String, dynamic> json) {
    return SmartInvoiceType(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      title: json['title'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'title': title,
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
