import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/color.dart';

class DateTimeAccordion extends StatefulWidget {
  const DateTimeAccordion({Key? key}) : super(key: key);

  @override
  State<DateTimeAccordion> createState() => _DateTimeAccordionState();
}

class _DateTimeAccordionState extends State<DateTimeAccordion> {
  bool isDate = true;
  bool isStartTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedTime = DateFormat('h:mm a').format(DateTime.now());
  String selectedTime2 =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    // CupertinoDatePicker(
    //   mode: CupertinoDatePickerMode.date,
    //   initialDateTime: now,
    //   onDateTimeChanged: (DateTime newDate) {
    //     setState(() {
    //       selectedDate =
    //           DateFormat('dd/MM/yyyy').format(newDate);
    //     });
    //   },
    // )
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedTime, selectedTime2),
        // Show or hide the content based on the state
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: (isDate)
                    ? CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 99),
                        onDateChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate =
                                DateFormat('dd/MM/yyyy').format(newDate);
                          });
                        },
                      )
                    : (isStartTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedTime =
                                    DateFormat('h:mm a').format(newTime);
                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateTime.now().add(const Duration(hours: 1)),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedTime2 =
                                    DateFormat('h:mm a').format(newTime);
                              });
                            },
                          ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date, String timeStart, String timeEnd) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isDate = true;
                      // if (_showContent) {
                      //   _showContent = !_showContent;
                      //   _showContent = true;
                      //   return;
                      // }
                      _height = 280;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.appBgColor)),
                  child: Text(
                    date,
                    style: const TextStyle(color: AppColors.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isStartTime = true;
                      isDate = false;
                      // if (_showContent) {
                      //   _showContent = !_showContent;
                      //   _showContent = true;
                      //   return;
                      // }
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.appBgColor)),
                  child: Text(
                    timeStart,
                    style: const TextStyle(color: AppColors.darker),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      isStartTime = false;
                      isDate = false;
                      if (_showContent && isStartTime == false) {
                        _showContent = !_showContent;
                        _showContent = true;
                        return;
                      }
                      _height = 200;
                      _showContent = !_showContent;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.appBgColor)),
                  child: Text(
                    timeEnd,
                    style: const TextStyle(color: AppColors.darker),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _showContent = false;
  }
}

class DateAccordion extends StatefulWidget {
  const DateAccordion({Key? key, required this.onDateChanged})
      : super(key: key);

  /// Called when the user selects a date in the picker.
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<DateAccordion> createState() => _DateAccordionState();
}

class _DateAccordionState extends State<DateAccordion> {
  late bool _showContent;

  late final double _height = 280;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedTime = DateFormat('h:mm a').format(DateTime.now());
  String selectedTime2 =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate),
        _showContent
            ? Container(
                height: _height,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 99),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = DateFormat('dd/MM/yyyy').format(newDate);

                      widget.onDateChanged(newDate);
                    });
                  },
                ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                    _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _showContent = !_showContent;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _showContent = false;
  }
}
