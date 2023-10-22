import 'package:smart_case/models/smart_model.dart';

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
