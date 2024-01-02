import 'package:intl/intl.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/employee/employee_model.dart';
import 'package:smart_case/database/file/file_model.dart';

class SmartDoneActivityReport {
  int id;
  String description;
  int state;
  DateTime date;
  DateTime from;
  DateTime to;
  int isBillable;
  int isLocked;
  String? lockedBy;
  int caseFileId;
  int caseActivityStatusId;
  int employeeId;
  String? notifyClient;
  SmartFile caseFile;
  SmartEmployee employee;
  SmartActivityStatus caseActivityStatus;

  SmartDoneActivityReport({
    required this.id,
    required this.description,
    required this.state,
    required this.date,
    required this.from,
    required this.to,
    required this.isBillable,
    required this.isLocked,
    this.lockedBy,
    required this.caseFileId,
    required this.caseActivityStatusId,
    required this.employeeId,
    this.notifyClient,
    required this.caseFile,
    required this.employee,
    required this.caseActivityStatus,
  });

  factory SmartDoneActivityReport.fromJson(Map<String, dynamic> json) {
    var now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    return SmartDoneActivityReport(
      id: json['id'],
      description: json['description'],
      state: json['state'],
      date: DateTime.parse(json['date']),
      from: DateTime.parse("$now ${json['from']}.000"),
      to: DateTime.parse("$now ${json['to']}.000"),
      isBillable: json['is_billable'],
      isLocked: json['is_locked'],
      lockedBy: json['locked_by'],
      caseFileId: json['case_file_id'],
      caseActivityStatusId: json['case_activity_status_id'],
      employeeId: json['employee_id'],
      notifyClient: json['notify_client'],
      caseFile: SmartFile.fromJson(json['case_file']),
      employee: SmartEmployee.fromJson(json['employee']),
      caseActivityStatus:
          SmartActivityStatus.fromJson(json['case_activity_status']),
    );
  }
}
