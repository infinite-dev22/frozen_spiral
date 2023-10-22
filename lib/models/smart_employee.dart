class SmartEmployee {
  final int id;
  final String title;
  final String code;
  final String? description;
  final int isActive;
  final int createdBy;
  final int? updatedBy;
  final String? createdAt;
  final String? updatedAt;

  SmartEmployee({
    required this.id,
    required this.title,
    required this.code,
    this.description,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

  factory SmartEmployee.fromJson(Map<String, dynamic> doc) {
    return SmartEmployee(
      id: doc['id'],
      title: doc['title'],
      code: doc['code'],
      description: doc['description'],
      isActive: doc['is_active'],
      createdBy: doc['created_by'],
      updatedBy: doc['updated_by'],
      createdAt: doc['created_at'],
      updatedAt: doc['updated_at'],
    );
  }
}