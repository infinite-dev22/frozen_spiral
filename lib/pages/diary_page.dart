import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final List<String> _subjectCollection = <String>[];
  final List<Color> _colorCollection = <Color>[];
  final _MeetingDataSource _events = _MeetingDataSource(<_Meeting>[]);
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
    addAppointmentDetails();
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
    final List<_Meeting> appointment = <_Meeting>[];
    _events.appointments.clear();
    final Random random = Random();

    /// Creates new appointment collection based on
    /// the visible dates in calendar.
    if (_calendarController.view != CalendarView.schedule) {
      for (int i = 0; i < visibleDatesChangedDetails.visibleDates.length; i++) {
        final DateTime date = visibleDatesChangedDetails.visibleDates[i];
        final int count = 1 + random.nextInt(3);
        for (int j = 0; j < count; j++) {
          final DateTime startDate =
              DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
          appointment.add(_Meeting(
            _subjectCollection[random.nextInt(7)],
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            _colorCollection[random.nextInt(9)],
            false,
          ));
        }
      }
    } else {
      final DateTime rangeStartDate =
          DateTime.now().add(const Duration(days: -(365 ~/ 2)));
      final DateTime rangeEndDate =
          DateTime.now().add(const Duration(days: 365));
      for (DateTime i = rangeStartDate;
          i.isBefore(rangeEndDate);
          i = i.add(const Duration(days: 1))) {
        final DateTime date = i;
        final int count = 1 + random.nextInt(3);
        for (int j = 0; j < count; j++) {
          final DateTime startDate =
              DateTime(date.year, date.month, date.day, 8 + random.nextInt(8));
          appointment.add(_Meeting(
            _subjectCollection[random.nextInt(7)],
            startDate,
            startDate.add(Duration(hours: random.nextInt(3))),
            _colorCollection[random.nextInt(9)],
            false,
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

  /// Creates the required appointment details as a list.
  void addAppointmentDetails() {
    _subjectCollection.add('General Meeting');
    _subjectCollection.add('Plan Execution');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Development Meeting');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Project Completion');
    _subjectCollection.add('Release updates');
    _subjectCollection.add('Performance Check');

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
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
class _MeetingDataSource extends CalendarDataSource<_Meeting> {
  _MeetingDataSource(this.source);

  List<_Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  _Meeting convertAppointmentToObject(
      _Meeting eventName, Appointment appointment) {
    return _Meeting(appointment.subject, appointment.startTime,
        appointment.endTime, appointment.color, appointment.isAllDay);
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class _Meeting {
  _Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
