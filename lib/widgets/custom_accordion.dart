import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/color.dart';

class DateTimeAccordion extends StatefulWidget {
  const DateTimeAccordion({Key? key, required this.name, required this.dateController, required this.timeController}) : super(key: key);

  final String name;
  final TextEditingController dateController;
  final TextEditingController timeController;

  @override
  State<DateTimeAccordion> createState() => _DateTimeAccordionState();
}

class _DateTimeAccordionState extends State<DateTimeAccordion> {
  bool isDate = true;
  bool isTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedTime = DateFormat('h:mm a').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedTime),
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
                            widget.dateController.text = selectedDate;
                          });
                        },
                      )
                    : (isTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.timeController.text = selectedTime;
                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedTime =
                                    DateFormat('h:mm a').format(newTime);
                              });
                            },
                          ),
              )
            : Container()
      ]),
    );
  }

  _buildTimeField(String date, String time) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isDate = true;

                          if (_showContent && isTime) {
                            isTime = false;
                            _height = 280;
                            _showContent = true;
                            return;
                          }

                          isTime = false;
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
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 40,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isTime = true;

                          if (_showContent && isDate) {
                            isDate = false;
                            _showContent = true;
                            _height = 200;
                            return;
                          }

                          isDate = false;
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
                        time,
                        style: const TextStyle(color: AppColors.darker),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.dateController.text = selectedDate;
    widget.timeController.text = selectedTime;
    _showContent = false;
  }
}

class DateTimeAccordion2 extends StatefulWidget {
  const DateTimeAccordion2({Key? key, required this.dateController, required this.startTimeController, required this.endTimeController}) : super(key: key);

  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;

  @override
  State<DateTimeAccordion2> createState() => _DateTimeAccordion2State();
}

class _DateTimeAccordion2State extends State<DateTimeAccordion2> {
  bool isDate = true;
  bool isStartTime = true;
  bool isEndTime = true;

  late bool _showContent;

  late double _height = 200;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String selectedStartTime = DateFormat('h:mm a').format(DateTime.now());
  String selectedEndTime =
      DateFormat('h:mm a').format(DateTime.now().add(const Duration(hours: 1)));

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildTimeField(selectedDate, selectedStartTime, selectedEndTime),
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
                            widget.dateController.text = selectedDate;
                          });
                        },
                      )
                    : (isStartTime)
                        ? CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedStartTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.startTimeController.text = selectedStartTime;

                              });
                            },
                          )
                        : CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime:
                                DateTime.now().add(const Duration(hours: 1)),
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                selectedEndTime =
                                    DateFormat('h:mm a').format(newTime);
                                widget.endTimeController.text = selectedEndTime;
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

                      if (_showContent && isStartTime || isEndTime) {
                        isEndTime = false;
                        isStartTime = false;
                        _height = 280;
                        _showContent = true;
                        return;
                      }

                      isEndTime = false;
                      isStartTime = false;
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

                      if (_showContent && isDate || isEndTime) {
                        isDate = false;
                        isEndTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isEndTime = false;
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
                      isEndTime = true;

                      if (_showContent && isStartTime || isDate) {
                        isDate = false;
                        isStartTime = false;
                        _showContent = true;
                        _height = 200;
                        return;
                      }

                      isDate = false;
                      isStartTime = false;
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
    widget.dateController.text = selectedDate;
    widget.startTimeController.text = selectedStartTime;
    widget.endTimeController.text = selectedEndTime;
    _showContent = false;
  }
}

class DateAccordion extends StatefulWidget {
  const DateAccordion({Key? key, required this.dateController})
      : super(key: key);

  final TextEditingController dateController;

  @override
  State<DateAccordion> createState() => _DateAccordionState();
}

class _DateAccordionState extends State<DateAccordion> {
  late bool _showContent;

  late final double _height = 280;

  DateTime now = DateTime.now();

  String selectedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        _buildDateField(selectedDate),
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

                      widget.dateController.text = selectedDate;
                    });
                  },
                ),
              )
            : Container()
      ]),
    );
  }

  _buildDateField(String date) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showContent = !_showContent;
        });
      },
      child: Container(
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
                Icon(
                    _showContent
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.dateController.text = selectedDate;
    _showContent = false;
  }
}
