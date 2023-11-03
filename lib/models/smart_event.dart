import 'package:intl/intl.dart';
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
  final bool? isAllDay;
  final SmartFile? file;

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
    this.isAllDay,
    this.file,
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

  factory SmartEvent.fromJson(Map<String, dynamic> doc) {
    return SmartEvent(
      id: doc['id'],
      title: doc['title'],
      description: doc['description'],
      url: doc['url'],
      editable: doc['editable'],
      startDate: DateTime.parse(doc['start']),
      startTime: DateFormat('h:mm a')
          .parse(DateFormat('h:mm a').format(DateTime.parse(doc['start']))),
      endDate: DateTime.parse(doc['end']),
      endTime: DateFormat('h:mm a')
          .parse(DateFormat('h:mm a').format(DateTime.parse(doc['end']))),
      backgroundColor: doc['backgroundColor'],
      borderColor: doc['borderColor'],
      fullName: doc['full_name'],
    );
  }

  // factory SmartEvent.fromJson(Map<String, dynamic> doc) {
  //   return SmartEvent(
  //     id: doc['id'],
  //     title: doc['title'],
  //     description: doc['description'],
  //     url: doc['url'],
  //     editable: doc['editable'],
  //     startDate: DateFormat('dd/MM/yyyy')
  //         .parse(DateFormat('dd/MM/yyyy').format(DateTime.parse(doc['start']))),
  //     startTime: DateFormat('h:mm a')
  //         .parse(DateFormat('h:mm a').format(DateTime.parse(doc['start']))),
  //     endDate: DateFormat('dd/MM/yyyy')
  //         .parse(DateFormat('dd/MM/yyyy').format(DateTime.parse(doc['end']))),
  //     endTime: DateFormat('h:mm a')
  //         .parse(DateFormat('h:mm a').format(DateTime.parse(doc['end']))),
  //     backgroundColor: doc['backgroundColor'],
  //     borderColor: doc['borderColor'],
  //     fullName: doc['full_name'],
  //   );
  // }
}
