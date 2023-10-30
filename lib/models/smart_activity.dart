import 'package:smart_case/models/smart_model.dart';

class SmartActivity extends SmartModel {
  int? id;
  String? name;
  String? description;
  String? code;
  int? categoryId;
  int? isActive;
  int? caseActivityStatusId;
  String? activityDate;
  final String? fileNumber;
  final String? courtFileNumber;
  final int? employeeId;
  final DateTime? date;
  final String? billable;
  final DateTime? startTime;
  final DateTime? endTime;
  final List? emails;

  SmartActivity({
    this.id,
    this.name,
    this.description,
    this.code,
    this.categoryId,
    this.isActive,
    this.caseActivityStatusId,
    this.activityDate,
    this.fileNumber,
    this.courtFileNumber,
    this.employeeId,
    this.date,
    this.billable,
    this.startTime,
    this.endTime,
    this.emails,
  });

  factory SmartActivity.fromJson(Map json) {
    return SmartActivity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
      categoryId: json['category_id'],
      isActive: json['is_active'],
      caseActivityStatusId: json['case_activity_status_id'],
      fileNumber: json['file_number'],
      courtFileNumber: json['court_file_number'],
      activityDate: json['created_at'],
      employeeId: json['employee_id'],
      date: json['date'],
      billable: json['billable'],
      startTime: json['from'],
      endTime: json['to'],
      emails: json['to_be_notified'],
    );
  }

  static toJson(SmartActivity activity) {
    return {
      'id': activity.id,
      'name': activity.name,
      'description': activity.description,
      'code': activity.code,
      'category_id': activity.categoryId,
      'is_active': activity.isActive,
      'file_number': activity.fileNumber,
      'court_file_number': activity.courtFileNumber,
      'created_at': activity.activityDate,
    };
  }

  static toActivityCreateJson(SmartActivity activity) {
    return {
      'description': activity.description,
      'case_activity_status_id': activity.caseActivityStatusId,
      'employee_id': activity.employeeId,
      'date': activity.date,
      'billable': activity.billable,
      'from': activity.startTime,
      'to': activity.endTime,
      'to_be_notified': activity.emails,
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
