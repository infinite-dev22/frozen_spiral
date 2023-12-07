import 'package:intl/intl.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_model.dart';

class SmartActivity extends SmartModel {
  final int? id;
  final String? name;
  final String? description;
  final String? code;
  final int? categoryId;
  final int? isActive;
  final int? caseActivityStatusId;
  final String? activityDate;
  final String? fileNumber;
  final String? courtFileNumber;
  final int? employeeId;
  final DateTime? date;
  final dynamic billable;
  final DateTime? startTime;
  final DateTime? endTime;
  final List? emails;
  final SmartEmployee? employee;
  final SmartFile? file;
  final SmartActivityStatus? caseActivityStatus;
  final int? createdBy;

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
    this.employee,
    this.file,
    this.caseActivityStatus,
    this.createdBy,
  });

  factory SmartActivity.fromJson(Map json) {
    List<int> timeFromList = json['from'].toString().split(":").toList().map(int.parse).toList();
    List<int> timeToList = json['to'].toString().split(":").toList().map(int.parse).toList();

    return SmartActivity(
      id: json['id'],
      name: json['case_activity_status']['name'],
      description: json['description'],
      code: json['case_activity_status']['code'],
      categoryId: json['case_activity_status']['category_id'],
      isActive: json['case_activity_status']['is_active'],
      caseActivityStatusId: json['case_activity_status_id'],
      fileNumber: json['case_file']['file_number'],
      courtFileNumber: json['case_file']['court_file_number'],
      activityDate: json['created_at'],
      employeeId: json['employee_id'],
      date: DateTime.parse(json['date']),
      billable: json['is_billable'],
      startTime: DateTime(1970, 01, 10, timeFromList[0], timeFromList[1], timeFromList[2]),
      endTime: DateTime(1970, 01, 10, timeToList[0], timeToList[1], timeToList[2]),
      emails: json['to_be_notified'],
      employee: SmartEmployee.fromJson(json['employee']),
      file: SmartFile.fromJson(json['case_file']),
      caseActivityStatus:
          SmartActivityStatus.fromJson(json['case_activity_status']),
      createdBy: json['created_by'],
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
      'file': activity.file,
      'created_at': activity.activityDate,
    };
  }

  static toActivityCreateJson(SmartActivity activity) {
    return {
      'description': activity.description,
      'case_activity_status_id': activity.caseActivityStatusId,
      'employee_id': activity.employeeId,
      'date': DateFormat('dd/MM/yyyy').format(activity.date!),
      'billable': activity.billable,
      'from': DateFormat('h:mm a').format(activity.startTime!),
      'to': DateFormat('h:mm a').format(activity.endTime!),
      'to_be_notified': activity.emails,
      'file': activity.file,
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

class SmartActivityStatus extends SmartModel {
  int? id;
  String? name;
  String? description;
  String? code;
  int? categoryId;
  int? isActive;

  SmartActivityStatus({
    this.id,
    this.name,
    this.description,
    this.code,
    this.categoryId,
    this.isActive,
  });

  factory SmartActivityStatus.fromJson(Map<String, dynamic> json) {
    return SmartActivityStatus(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      code: json['code'],
      categoryId: json['category_id'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'category_id': categoryId,
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
