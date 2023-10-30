class SmartEvent {
  final String title;
  final String description;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final int employeeId;
  final int caseActivityStatusId;
  final int calendarEventTypeId;
  final int externalTypeId;
  final String firmEvent;
  final String notifyOnDate;
  final String notifyOnTime;
  final List<String> employeeIds;
  final List toBeNotified;

  SmartEvent({
    required this.title,
    required this.description,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.employeeId,
    required this.caseActivityStatusId,
    required this.calendarEventTypeId,
    required this.externalTypeId,
    required this.firmEvent,
    required this.notifyOnDate,
    required this.notifyOnTime,
    required this.employeeIds,
    required this.toBeNotified,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_date': startDate.toString(),
      'start_time': startTime.toString(),
      'end_date': endDate.toString(),
      'end_time': endTime.toString(),
      'employee_id': employeeId,
      'case_activity_status_id': caseActivityStatusId,
      'calendar_event_type_id': calendarEventTypeId,
      'external_type_id': externalTypeId,
      'firm_event': firmEvent,
      'notify_on_date': notifyOnDate.toString(),
      'notify_on_time': notifyOnTime.toString(),
      'employee_ids': employeeIds,
      'to_be_notified': toBeNotified,
    };
  }

  factory SmartEvent.fromJson(Map<String, dynamic> doc) {
    return SmartEvent(
      title: doc['title'],
      description: doc['description'],
      startDate: doc['start_date'],
      startTime: doc['start_time'],
      endDate: doc['end_date'],
      endTime: doc['end_time'],
      employeeId: doc['employee_id'],
      caseActivityStatusId: doc['case_activity_status_id'],
      calendarEventTypeId: doc['calendar_event_type_id'],
      externalTypeId: doc['external_type_id'],
      firmEvent: doc['firm_event'],
      notifyOnDate: doc['notify_on_date'],
      notifyOnTime: doc['notify_on_time'],
      employeeIds: List<String>.from(doc['employee_ids']),
      toBeNotified: List<String>.from(doc['to_be_notified']),
    );
  }
}