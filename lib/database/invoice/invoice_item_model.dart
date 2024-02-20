import 'package:smart_case/database/smart_model.dart';

class SmartInvoiceItem extends SmartModel {
  final int? id;
  final String? name;
  final String? description;
  final String? code;

  SmartInvoiceItem({
    this.id,
    this.name,
    this.description,
    this.code,
  });

  factory SmartInvoiceItem.fromJson(Map<String, dynamic> json) {
    return SmartInvoiceItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'code': code,
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
