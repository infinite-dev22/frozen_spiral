import 'package:smart_case/database/smart_model.dart';

class SmartCurrency extends SmartModel {
  final int? id;
  final String? name;
  final String? code;
  final int? isActive;

  SmartCurrency({
    required this.id,
    required this.name,
    required this.code,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'is_active': isActive,
    };
  }

  factory SmartCurrency.fromJson(Map<String, dynamic> doc) {
    return SmartCurrency(
      id: doc['id'],
      name: doc['name'],
      code: doc['code'],
      isActive: doc['is_active'],
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
