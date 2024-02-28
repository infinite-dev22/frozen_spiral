import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/pages/event_page/widgets/event_form.dart';
import 'package:smart_case/pages/event_page/widgets/event_view.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

Map<DateTime, List<SmartEvent>> _dataCollection =
    <DateTime, List<SmartEvent>>{};

class _DiaryPageState extends State<DiaryPage> {
  List<SmartEvent> _events = List.empty(growable: true);
  late _EventDataSource _eventsDataSource;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
    CalendarView.schedule
  ];

  final CalendarController _calendarController = CalendarController();

  final bool _showLeadingAndTrailingDates = false;
  final bool _showDatePickerButton = true;
  final bool _allowViewNavigation = true;
  final bool _showCurrentTimeIndicator = true;

  final ViewNavigationMode _viewNavigationMode = ViewNavigationMode.snap;
  final bool _showWeekNumber = false;
  final int _numberOfDays = -1;

  @override
  void initState() {
    _fetchEvents().then((value) => _dataCollection = value);
    _eventsDataSource = _EventDataSource(<SmartEvent>[]);
    _calendarController.view = CalendarView.month;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = _getGettingStartedCalendar(
      _calendarController,
      _eventsDataSource,
      _onViewChanged,
      scheduleViewBuilder,
    );

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          canNavigate: true,
          isNetwork: currentUser.avatar != null ? true : false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buildDairyForm,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Row(children: <Widget>[
        Expanded(
          child: Container(
            color: AppColors.white,
            child: calendar,
          ),
        )
      ]),
    );
  }

  _buildDairyForm() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const DiaryForm(),
    );
  }

  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view, based on the view changed
  /// details new appointment collection added to the calendar
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    visibleDatesChangedDetails.visibleDates.sort();
    var minDate = DateFormat('yyyy-MM-dd')
        .format(visibleDatesChangedDetails.visibleDates.first);
    var maxDate = DateFormat('yyyy-MM-dd').format(visibleDatesChangedDetails
        .visibleDates.last
        .add(const Duration(days: 1)));

    final List<SmartEvent> appointments = <SmartEvent>[];
    // _eventsDataSource.appointments.clear();

    if (_calendarController.view == CalendarView.month ||
        _calendarController.view == CalendarView.week) {
      _fetchEventsDynamic(minDate: minDate, maxDate: maxDate);
    } else if (_calendarController.view == CalendarView.day) {
      _fetchEventsDynamic(
          minDate: minDate,
          maxDate: DateFormat('yyyy-MM-dd').format(visibleDatesChangedDetails
              .visibleDates.last
              .add(const Duration(days: 1))));
    }

    /// Creates new appointment collection based on
    /// the visible dates in calendar.
    if (_events.isNotEmpty) {
      if (_calendarController.view != CalendarView.schedule) {
        for (int i = 0; i < _events.length; i++) {
          appointments.add(SmartEvent(
            title: _events[i].description,
            startDate: _events[i].startDate,
            endDate: _events[i].endDate,
            backgroundColor: _events[i].backgroundColor,
          ));
        }
      } else {
        for (int i = 0; i < _events.length; i++) {
          appointments.add(SmartEvent(
            title: _events[i].description,
            startDate: _events[i].startDate,
            endDate: _events[i].endDate,
            backgroundColor: _events[i].backgroundColor,
          ));
        }
      }
    }

    _eventsDataSource.appointments = appointments;

    /// Resets the newly created appointment collection to render
    /// the appointments on the visible dates.
    _eventsDataSource.notifyListeners(
      CalendarDataSourceAction.reset,
      appointments,
    );

    _eventsDataSource.notifyListeners(
      CalendarDataSourceAction.addResource,
      appointments,
    );
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getGettingStartedCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      ViewChangedCallback? viewChangedCallback,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      allowAppointmentResize: true,
      dragAndDropSettings: const DragAndDropSettings(
          allowScroll: true,
          autoNavigateDelay: Duration(microseconds: 500),
          showTimeIndicator: true),
      showTodayButton: true,
      onTap: (calendarTapDetails) {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments!.isNotEmpty) {
          if (calendarTapDetails.appointments!.length == 1) {
            // if(calendarTapDetails.appointments![0].calendarEventTypeId == 1) {  // Check for type if calendar event then show else don't
            _buildEventView(calendarTapDetails.appointments![0]);
            // }
            setState(() {});
          }
        }
      },
      controller: calendarController,
      dataSource: _EventDataSource(_events),
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showDatePickerButton: _showDatePickerButton,
      allowViewNavigation: _allowViewNavigation,
      showCurrentTimeIndicator: _showCurrentTimeIndicator,
      loadMoreWidgetBuilder:
          (BuildContext context, LoadMoreCallback loadMoreAppointments) {
        return FutureBuilder<void>(
          future: loadMoreAppointments(),
          builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
            return Container(
                height: _calendarController.view == CalendarView.schedule
                    ? 50
                    : double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          },
        );
      },
      onViewChanged: viewChangedCallback,
      blackoutDatesTextStyle: const TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.red),
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showTrailingAndLeadingDates: _showLeadingAndTrailingDates),
      timeSlotViewSettings: TimeSlotViewSettings(
          numberOfDaysInView: _numberOfDays,
          minimumAppointmentDuration: const Duration(minutes: 60)),
      viewNavigationMode: _viewNavigationMode,
      showWeekNumber: _showWeekNumber,
    );
  }

  Future<Map<DateTime, List<SmartEvent>>> _fetchEvents(
      {String? minDate, String? maxDate}) async {
    _events.clear();
    _dataCollection.clear();

    var now = DateTime.now();
    var responseEventsList = await SmartCaseApi.smartDioFetch(
        'api/calendar/eventsDispapi', currentUser.token,
        body: {
          "start": minDate ?? "${now.year}-${now.month}-01",
          "end": maxDate ??
              "${now.year}-${now.month}-${DateTime(now.year, now.month + 1, 0).day}",
          "viewRdbtn": "all",
          "isFirmEventRdbtn": "ALLEVENTS",
          "checkedChk": ["MEETING", "NEXTACTIVITY", "LEAVE", "HOLIDAY"],
        });
    try {
      List eventsList = jsonDecode(responseEventsList);
      _events = eventsList.map((doc) => SmartEvent.fromJson(doc)).toList();
    } on TypeError {
      String eventsListString = jsonEncode(responseEventsList);
      List eventsList = jsonDecode(eventsListString);
      _events = eventsList.map((doc) => SmartEvent.fromJson(doc)).toList();
    }

    var dataCollection = <DateTime, List<SmartEvent>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1000));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      for (int j = 0; j < _events.length; j++) {
        final SmartEvent event = SmartEvent(
          title: _events[j].description,
          startDate: _events[j].startDate,
          endDate: _events[j].endDate,
          backgroundColor: _events[j].backgroundColor,
        );

        if (dataCollection.containsKey(date)) {
          final List<SmartEvent> events = dataCollection[date]!;
          events.add(event);
          dataCollection[date] = events;
        } else {
          dataCollection[date] = [event];
        }
      }
    }
    return dataCollection;
  }

  Future<Map<DateTime, List<SmartEvent>>> _fetchEventsDynamic(
      {String? minDate, String? maxDate}) async {
    _events.clear();
    _dataCollection.clear();

    var now = DateTime.now();

    var responseEventsList = await SmartCaseApi.smartDioFetch(
        'api/calendar/events', currentUser.token,
        body: {
          "start": minDate ?? "${now.year}-${now.month}-01",
          "end": maxDate ??
              "${now.year}-${now.month}-${DateTime(now.year, now.month + 1, 0).day}",
          "viewRdbtn": "all",
          "isFirmEventRdbtn": "ALLEVENTS",
          "checkedChk": ["MEETING", "NEXTACTIVITY", "LEAVE", "HOLIDAY"]
        });
    List eventsList = jsonDecode(responseEventsList);
    _events = eventsList.map((doc) => SmartEvent.fromJson(doc)).toList();

    var dataCollection = <DateTime, List<SmartEvent>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1000));
    for (DateTime i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      for (int j = 0; j < _events.length; j++) {
        final SmartEvent event = SmartEvent(
          title: _events[j].title,
          startDate: _events[j].startDate,
          endDate: _events[j].endDate,
          backgroundColor: _events[j].backgroundColor,
          notifyOnDate: _events[j].notifyOnDate,
          toBeNotified: _events[j].toBeNotified,
          fullName: _events[j].fullName,
          isAllDay: false,
          description: _events[j].description,
          url: _events[j].url,
        );

        if (dataCollection.containsKey(date)) {
          final List<SmartEvent> events = dataCollection[date]!;
          events.add(event);
          dataCollection[date] = events;
        } else {
          dataCollection[date] = [event];
        }
      }
    }
    if (mounted) setState(() {});
    return dataCollection;
  }

  _buildEventView(SmartEvent event) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => EventView(eventId: event.id!),
    );
  }
}

/// Returns the month name based on the month value passed from date.
String _getMonthDate(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}

/// Returns the builder for schedule view.
Widget scheduleViewBuilder(
  BuildContext buildContext,
  ScheduleViewMonthHeaderDetails details,
) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: <Widget>[
      Image(
          image:
              ExactAssetImage('assets/images/calendar_images/$monthName.png'),
          fit: BoxFit.cover,
          width: details.bounds.width,
          height: details.bounds.height),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          '$monthName ${details.date.year}',
          style: const TextStyle(fontSize: 18),
        ),
      )
    ],
  );
}

/// An object to set the appointment collection data source to collection, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class _EventDataSource extends CalendarDataSource<SmartEvent> {
  _EventDataSource(this.source);

  List<SmartEvent> source;
  List<SmartEvent> events = List.empty(growable: true);

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].startDate!;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].endDate!;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }

  @override
  String getSubject(int index) {
    return source[index].title!;
  }

  @override
  Color getColor(int index) {
    return HexColor.fromHex(source[index].backgroundColor!);
  }

  @override
  SmartEvent convertAppointmentToObject(
      SmartEvent eventName, Appointment appointment) {
    return SmartEvent(
      description: appointment.subject,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      backgroundColor: HexColor(appointment.color).toHex(leadingHashSign: true),
      isAllDay: false,
    );
  }

  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    final List<SmartEvent> events = <SmartEvent>[];

    DateTime appStartDate =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime appEndDate = DateTime(endDate.year, endDate.month, endDate.day,
        DateTime(endDate.year, endDate.month + 1, 0).day);

    while (appStartDate.isBefore(appEndDate)) {
      final List<SmartEvent>? data = _dataCollection[appStartDate];
      if (data == null) {
        appStartDate = appStartDate.add(const Duration(days: 1));
        continue;
      }

      for (final SmartEvent event in data) {
        if (appointments.contains(event)) {
          continue;
        }
        events.add(event);
      }
      appStartDate = appStartDate.add(const Duration(days: 1));
    }

    appointments.addAll(events);
    notifyListeners(CalendarDataSourceAction.add, events);
  }
}
