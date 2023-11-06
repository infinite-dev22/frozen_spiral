import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_employee.dart';
import 'package:smart_case/models/smart_file.dart';

class SmartEvent {
  final int? id;
  final String? title;
  final String? description;
  final String? url;
  final bool? editable;
  final String? backgroundColor;
  final String? borderColor;
  final String? fullName;
  final DateTime? startDate;
  final DateTime? startTime;
  final DateTime? endDate;
  final DateTime? endTime;
  final int? employeeId;
  final int? caseActivityStatusId;
  final int? calendarEventTypeId;
  final int? externalTypeId;
  final String? firmEvent;
  final DateTime? notifyOnDate;
  final DateTime? notifyOnTime;
  final List<String>? employeeIds;
  final List? toBeNotified;
  final List<SmartEmployee>? toNotify;
  final bool? isAllDay;
  final SmartFile? file;
  final int? activityStatusId;

  SmartEvent({
    this.id,
    this.url,
    this.editable,
    this.backgroundColor,
    this.borderColor,
    this.fullName,
    this.title,
    this.description,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.employeeId,
    this.caseActivityStatusId,
    this.calendarEventTypeId,
    this.externalTypeId,
    this.firmEvent,
    this.notifyOnDate,
    this.notifyOnTime,
    this.employeeIds,
    this.toBeNotified,
    this.toNotify,
    this.isAllDay,
    this.file,
    this.activityStatusId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': DateFormat('dd/MM/yyyy').format(startDate!),
      'start_time': DateFormat('h:mm a').format(startTime!),
      'end_date': DateFormat('dd/MM/yyyy').format(endDate!),
      'end_time': DateFormat('h:mm a').format(endTime!),
      'employee_id': employeeId,
      'case_activity_status_id': caseActivityStatusId,
      'calendar_event_type_id': calendarEventTypeId,
      'external_type_id': externalTypeId,
      'firm_event': firmEvent,
      'notify_on_date': DateFormat('dd/MM/yyyy').format(notifyOnDate!),
      'notify_on_time': DateFormat('h:mm a').format(notifyOnTime!),
      'employee_ids': employeeIds,
      'to_be_notified': toBeNotified,
    };
  }

  factory SmartEvent.fromJsonView(Map<dynamic, dynamic> doc) {
    Map<String, dynamic> param = jsonDecode(doc["calendarEvents"]['params']);
    Map toNotifyMap = doc['toNotify'];
    List<SmartEmployee> toNotifyList = List.empty(growable: true);
    toNotifyMap.forEach((key, value) {
      toNotifyList.add(SmartEmployee.fromJson(value["employee"]));
    });
    return SmartEvent(
      id: doc["calendarEvents"]['id'],
      title: doc["calendarEvents"]['title'],
      description: doc["calendarEvents"]['description'],
      url: doc["calendarEvents"]['url'],
      editable: doc["calendarEvents"]['editable'],
      startDate: DateTime.parse(doc["calendarEvents"]['start']),
      startTime: DateFormat('h:mm a').parse(DateFormat('h:mm a')
          .format(DateTime.parse(doc["calendarEvents"]['start']))),
      endDate: DateTime.parse(doc["calendarEvents"]['end']),
      endTime: DateFormat('h:mm a').parse(DateFormat('h:mm a')
          .format(DateTime.parse(doc["calendarEvents"]['end']))),
      backgroundColor: doc["calendarEvents"]['backgroundColor'],
      borderColor: doc["calendarEvents"]['borderColor'],
      fullName:
          "${doc["calendarEvents"]['created_by']['employee']['first_name']}"
          " ${doc["calendarEvents"]['created_by']['employee']['middle_name']}"
          " ${doc["calendarEvents"]['created_by']['employee']['last_name']}",
      activityStatusId: param['case_activity_status_id'],
      file: SmartFile.fromJson(doc['caseFile']),
      notifyOnDate: DateTime.parse(doc['notifyOn']),
      notifyOnTime: DateTime.parse(doc['notifyOn']),
      toNotify: toNotifyList,
    );
  }

  factory SmartEvent.fromJson(Map<String, dynamic> doc) {
    return SmartEvent(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      url: doc['url'],
      editable: doc['editable'],
      startDate: DateFormat('dd/MM/yyyy')
          .parse(DateFormat('dd/MM/yyyy').format(DateTime.parse(doc['start']))),
      startTime: DateFormat('h:mm a')
          .parse(DateFormat('h:mm a').format(DateTime.parse(doc['start']))),
      endDate: DateFormat('dd/MM/yyyy')
          .parse(DateFormat('dd/MM/yyyy').format(DateTime.parse(doc['end']))),
      endTime: DateFormat('h:mm a')
          .parse(DateFormat('h:mm a').format(DateTime.parse(doc['end']))),
      backgroundColor: doc['backgroundColor'],
      borderColor: doc['borderColor'],
      fullName: doc['full_name'],
    );
  }
}
