import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/models/smart_model.dart';

class SmartTask extends SmartModel {
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
  final DateTime? estimatedTime;
  final DateTime? createdAt;
  final List<SmartEmployee>? assignees;
  final SmartEmployee? assigner;
  final SmartFile? caseFile;
  final SmartTaskStatus? taskStatuses;

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
      dueAt: DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy')
          .format(DateFormat('yy-MM-dd').parse(json['due_at']))),
      taskStatus: json['task_status'],
      endDate: (json['end_date'] != null)
          ? DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy')
              .format(DateFormat('dd-MM-yyyy').parse(json['end_date'])))
          : null,
      estimatedTime: DateFormat('h:mm a').parse(DateFormat('h:mm a')
          .format(DateFormat('h:mm a').parse(json['estimated_time']))),
      createdAt: DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy')
          .format(DateFormat('dd-MM-yyyy').parse(json['created_at']))),
      assignees: (json['assignees'] as List?)
          ?.map((e) => SmartEmployee.fromJson(e))
          .toList(),
      assigner: json['assigner'] != null
          ? SmartEmployee.fromJson(json['assigner'])
          : null,
      caseFile: json['case_file'] != null
          ? SmartFile.fromJson(json['case_file'])
          : null,
      taskStatuses: json['task_statuses'] != null
          ? SmartTaskStatus.fromJson(json['task_statuses'])
          : null,
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
      'task_statuses': taskStatuses,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      "formtype": "index",
      'task_name': taskName,
      'description': description,
      'matter': matter,
      'case_status': caseStatus,
      'priority': priority,
      'due_at': dueAt?.toIso8601String(),
      'task_status': taskStatus,
      'estimated_time': estimatedTime?.toIso8601String(),
      'assignees': assignees,
    };
  }

  @override
  int getId() {
    return id!;
  }

  @override
  String getName() {
    return taskName!;
  }
}

class SmartTaskStatus {
  int? id;
  String? name;
  String? code;
  String? description;

  SmartTaskStatus({
    this.id,
    this.name,
    this.code,
    this.description,
  });

  SmartTaskStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
    };
  }
}
