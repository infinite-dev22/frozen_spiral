import 'package:smart_case/models/smart_employee.dart';

import 'package:smart_case/models/smart_file.dart';

class SmartTask {
  final int? id;
  final String? formType;
  final String? taskName;
  final String? description;
  final int? matter;
  final String? caseStatus;
  final String? priority;
  final DateTime? dueAt;
  final int? taskStatus;
  final DateTime? endDate;
  final String? estimatedTime;
  final String? createdAt;
  final List<SmartEmployee>? assignees;
  final SmartEmployee? assigner;
  final SmartFile? caseFile;
  final dynamic taskStatuses;

  SmartTask({
    this.id,
    this.formType,
    this.taskName,
    this.description,
    this.matter,
    this.caseStatus,
    this.priority,
    this.dueAt,
    this.taskStatus,
    this.endDate,
    this.estimatedTime,
    this.createdAt,
    this.assignees,
    this.assigner,
    this.caseFile,
    this.taskStatuses,
  });

  factory SmartTask.fromJson(Map<String, dynamic> json) {
    return SmartTask(
      id: json['id'],
      formType: json['formtype'],
      taskName: json['task_name'],
      description: json['description'],
      matter: json['matter'],
      caseStatus: json['case_status'],
      priority: json['priority'],
      dueAt: json['due_at'],
      taskStatus: json['task_status'],
      endDate: json['end_date'],
      estimatedTime: json['estimated_time'],
      createdAt: json['created_at'],
      assignees: (json['assignees'] as List).map((e) => SmartEmployee.fromJson(e)).toList(),
      assigner: SmartEmployee.fromJson(json['assigner']),
      caseFile: SmartFile.fromJson(json['case_file']),
      taskStatuses: json['task_statuses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_name': taskName,
      'description': description,
      'matter': matter,
      'case_status': caseStatus,
      'due_at': dueAt?.toIso8601String(),
      'task_status': taskStatus,
      'end_date': endDate?.toIso8601String(),
      'estimated_time': estimatedTime,
      'assignees': assignees,
      'assigner': assigner?.toJson(),
      'case_file': SmartFile.toJson(caseFile!),
      'task_statuses': taskStatuses != null
          ? List<dynamic>.from(taskStatuses.map((x) => x.toJson()))
          : null,
    };
  }
}
