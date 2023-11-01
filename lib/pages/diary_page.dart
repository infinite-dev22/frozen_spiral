import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../services/apis/smartcase_api.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<SmartEvent> events = List.empty(growable: true);
  final _EventDataSource _events = _EventDataSource(<SmartEvent>[]);
  final DateTime _minDate =
          DateTime.now().subtract(const Duration(days: 365 ~/ 2)),
      _maxDate = DateTime.now().add(const Duration(days: 365 ~/ 2));

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.month,
    CalendarView.schedule
  ];

  final CalendarController _calendarController = CalendarController();

  final bool _showLeadingAndTrailingDates = true;
  final bool _showDatePickerButton = true;
  final bool _allowViewNavigation = true;
  final bool _showCurrentTimeIndicator = true;

  ViewNavigationMode _viewNavigationMode = ViewNavigationMode.snap;
  final bool _showWeekNumber = false;
  int _numberOfDays = -1;

  @override
  void initState() {
    _calendarController.view = CalendarView.month;
    _fetchEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendar = _getGettingStartedCalendar(_calendarController,
        _events, _onViewChanged, _minDate, _maxDate, scheduleViewBuilder);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          canNavigate: true,
          isNetwork: currentUserImage != null ? true : false,
        ),
      ),
      body: Row(children: <Widget>[
        Expanded(
          child: Container(color: AppColors.white, child: calendar),
        )
      ]),
    );
  }

  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view, based on the view changed
  /// details new appointment collection added to the calendar
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    final List<SmartEvent> appointment = <SmartEvent>[];
    _events.appointments.clear();

    /// Creates new appointment collection based on
    /// the visible dates in calendar.
    if (events.isNotEmpty) {
      if (_calendarController.view != CalendarView.schedule) {
        for (int i = 0; i < events.length; i++) {
          appointment.add(SmartEvent(
            title: events[i].title,
            startDate: events[i].startDate,
            endDate: events[i].endDate,
            startTime: events[i].startTime,
            endTime: events[i].endTime,
            backgroundColor: events[i].backgroundColor,
          ));
        }
      } else {
        for (int i = 0; i < events.length; i++) {
          appointment.add(SmartEvent(
            title: events[i].title,
            startDate: events[i].startDate,
            endDate: events[i].endDate,
            startTime: events[i].startTime,
            endTime: events[i].endTime,
            backgroundColor: events[i].backgroundColor,
          ));
        }
      }
    }

    for (int i = 0; i < appointment.length; i++) {
      _events.appointments.add(appointment[i]);
    }

    /// Resets the newly created appointment collection to render
    /// the appointments on the visible dates.
    _events.notifyListeners(CalendarDataSourceAction.reset, appointment);
  }

  _fetchEvents() async {
    var now = DateTime.now();
    var eventsList = await SmartCaseApi.smartDioFetch(
        'api/calendar/events', currentUser.token,
        body: {
          "start": "${now.year}-${now.month}-01",
          "end":
              "${now.year}-${now.month}-${DateTime(now.year, now.month + 1, 0).day}",
          "viewRdbtn": "all",
          "isFirmEventRdbtn": "ALLEVENTS",
          "checkedChk": ["MEETING", "NEXTACTIVITY", "LEAVE", "HOLIDAY"]
        });
    List currencyList = eventsList;
    events = currencyList.map((doc) => SmartEvent.fromJson(doc)).toList();
    print(events);
  }

  /// Allows/Restrict switching to previous/next views through swipe interaction
  void onViewNavigationModeChange(String value) {
    if (value == 'snap') {
      _viewNavigationMode = ViewNavigationMode.snap;
    } else if (value == 'none') {
      _viewNavigationMode = ViewNavigationMode.none;
    }
    setState(() {
      /// update the view navigation mode changes
    });
  }

  /// Allows to switching the days count customization in calendar.
  void customNumberOfDaysInView(String value) {
    if (value == 'default') {
      _numberOfDays = -1;
    } else if (value == '1 day') {
      _numberOfDays = 1;
    } else if (value == '2 days') {
      _numberOfDays = 2;
    } else if (value == '3 days') {
      _numberOfDays = 3;
    } else if (value == '4 days') {
      _numberOfDays = 4;
    } else if (value == '5 days') {
      _numberOfDays = 5;
    } else if (value == '6 days') {
      _numberOfDays = 6;
    } else if (value == '7 days') {
      _numberOfDays = 7;
    }
    setState(() {});
  }

  /// Returns the calendar widget based on the properties passed.
  SfCalendar _getGettingStartedCalendar(
      [CalendarController? calendarController,
      CalendarDataSource? calendarDataSource,
      ViewChangedCallback? viewChangedCallback,
      DateTime? minDate,
      DateTime? maxDate,
      dynamic scheduleViewBuilder]) {
    return SfCalendar(
      controller: calendarController,
      dataSource: calendarDataSource,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showDatePickerButton: _showDatePickerButton,
      allowViewNavigation: _allowViewNavigation,
      showCurrentTimeIndicator: _showCurrentTimeIndicator,
      onViewChanged: viewChangedCallback,
      blackoutDatesTextStyle: const TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.red),
      minDate: minDate,
      maxDate: maxDate,
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
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
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

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].startTime!;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].endTime!;
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
        backgroundColor:
            HexColor(appointment.color).toHex(leadingHashSign: true));
  }
}
