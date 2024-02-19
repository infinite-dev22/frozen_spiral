import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/contact/contact_model.dart';
import 'package:smart_case/database/event/event_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/database/user/user_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class DiaryForm extends StatefulWidget {
  const DiaryForm({
    super.key,
    this.event,
    this.activity,
  });

  final SmartEvent? event;
  final SmartActivityStatus? activity;

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final globalKey = GlobalKey();
  bool isTitleElevated = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController reminderDateController = TextEditingController();
  final TextEditingController reminderTimeController = TextEditingController();
  List emails = List.empty(growable: true);
  List<int?> employeeIds = List.empty(growable: true);

  final ValueNotifier<SmartActivity?> activitySelectedValue =
      ValueNotifier<SmartActivity?>(null);
  final ValueNotifier<SmartFile?> fileSelectedValue =
      ValueNotifier<SmartFile?>(null);

  List<SmartActivityStatus> activities = List.empty(growable: true);
  List<SmartContact> contacts = List.empty(growable: true);
  List<SmartUser> employees = List.empty(growable: true);

  SmartActivityStatus? activity;
  SmartFile? file;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          FormTitle(
            name: '${widget.event != null ? "Edit" : "New"} Calendar Event',
            addButtonText: widget.event != null ? "Update" : "Add",
            onSave: _submitFormData,
            isElevated: isTitleElevated,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                // FocusManager.instance.primaryFocus?.unfocus();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollController.position.userScrollDirection ==
                      ScrollDirection.reverse) {
                    setState(() {
                      isTitleElevated = true;
                    });
                  } else if (scrollController.position.userScrollDirection ==
                      ScrollDirection.forward) {
                    if (scrollController.position.pixels ==
                        scrollController.position.maxScrollExtent) {
                      setState(() {
                        isTitleElevated = false;
                      });
                    }
                  }
                  return true;
                },
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8),
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Form(
                        child: Column(
                          children: [
                            DoubleDateTimeAccordion(
                                startName: 'Starts on',
                                endName: 'Ends on',
                                startDateController: startDateController,
                                startTimeController: startTimeController,
                                endDateController: endDateController,
                                endTimeController: endTimeController),
                            GestureDetector(
                              onTap: _showSearchFileBottomSheet,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: SizedBox(
                                        width: constraints.maxWidth - 50,
                                        child: Text(
                                          file?.fileName ?? 'Select file',
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColors.darker,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.darker,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _showSearchActivityBottomSheet,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: SizedBox(
                                        width: constraints.maxWidth - 50,
                                        child: Text(
                                          activity?.name ??
                                              'Select activity status',
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColors.darker,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.darker,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (file != null && contacts.isNotEmpty)
                              Column(
                                children: [
                                  MultiSelectDropDown(
                                    clearIcon: Icon(FontAwesome.xmark_solid),
                                    hint: 'Select contact to notify',
                                    onOptionSelected: (options) {
                                      for (var element in options) {
                                        emails.add(element.value!);
                                      }
                                    },
                                    options: contacts
                                        .map((contact) => ValueItem(
                                            label:
                                                '${contact.name} - ${contact.email}',
                                            value:
                                                '${contact.name}|${contact.email}'))
                                        .toList(),
                                    selectionType: SelectionType.multi,
                                    chipConfig: const ChipConfig(
                                        wrapType: WrapType.wrap),
                                    dropdownHeight: 300,
                                    borderColor: AppColors.white,
                                    optionTextStyle:
                                        const TextStyle(fontSize: 16),
                                    selectedOptionIcon:
                                        const Icon(Icons.check_circle),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            DateTimeAccordion(
                              name: 'Set reminder',
                              dateController: reminderDateController,
                              timeController: reminderTimeController,
                            ),
                            if (file != null)
                              Column(
                                children: [
                                  MultiSelectDropDown(
                                    hint: 'Remind me with',
                                    searchEnabled: true,
                                    clearIcon: Icon(FontAwesome.xmark_solid),
                                    dropdownHeight: 300,
                                    onOptionSelected: (options) {
                                      for (var element in options) {
                                        employeeIds
                                            .add(int.parse(element.value!));
                                      }
                                    },
                                    options: employees
                                        .map((employee) => ValueItem(
                                            label: employee.getName(),
                                            value: employee.id.toString()))
                                        .toList(),
                                    selectionType: SelectionType.multi,
                                    chipConfig: const ChipConfig(
                                        wrapType: WrapType.wrap),
                                    borderColor: AppColors.white,
                                    optionTextStyle:
                                        const TextStyle(fontSize: 16),
                                    selectedOptionIcon:
                                        const Icon(Icons.check_circle),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            CustomTextArea(
                              key: globalKey,
                              hint: 'Description',
                              controller: descriptionController,
                              onTap: () {
                                Scrollable.ensureVisible(
                                    globalKey.currentContext!);
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showSearchFileBottomSheet() {
    List<SmartFile> searchedList = List.empty(growable: true);
    bool isLoading = false;
    return showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * .8),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AsyncSearchableBottomSheetContents(
                hint: "Search file",
                list: searchedList,
                onTap: (value) {
                  setState(() {
                    file = null;
                    _onTapSearchedFile(value!);
                  });
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (preloadedFiles.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(preloadedFiles.where((smartFile) =>
                            smartFile
                                .getName()
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadFiles();
                        isLoading = true;
                      }
                    }
                  });
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _showSearchActivityBottomSheet() {
    List<SmartActivityStatus> searchedList = List.empty(growable: true);
    bool isLoading = false;
    return showModalBottomSheet(
        isScrollControlled: true,
        constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height * .8),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AsyncSearchableBottomSheetContents(
                hint: "Search activity",
                list: searchedList,
                onTap: (value) {
                  _onTapSearchedActivity(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      if (activities.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(activities.where((activity) =>
                            activity.name!
                                .toLowerCase()
                                .contains(value.toLowerCase())));
                      } else {
                        _reloadActivities();
                        isLoading = true;
                      }
                    }
                  });
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _reloadActivities() async {
    Map activitiesMap = await SmartCaseApi.smartFetch(
        'api/admin/caseActivityStatus', currentUser.token);
    List activityList = activitiesMap['caseActivityStatus']['data'];

    activities =
        activityList.map((doc) => SmartActivityStatus.fromJson(doc)).toList();
    setState(() {});
  }

  _reloadFiles() async {
    await FileApi.fetchAll();
  }

  _loadContacts() async {
    Map contactsMap = await SmartCaseApi.smartFetch(
        'api/cases/${file!.id}/contactsandfinancialstatus', currentUser.token);

    List? contacts = contactsMap['contacts'];
    this.contacts = contacts!.map((doc) => SmartContact.fromJson(doc)).toList();
    // contacts = null;
    setState(() {});
  }

  @override
  void initState() {
    _setUpData();
    _loadEmployees();
    _fillDataForUpdate();

    super.initState();
  }

  Future<void> _setUpData() async {
    Map activitiesMap = await SmartCaseApi.smartFetch(
        'api/admin/caseActivityStatus', currentUser.token);
    List activityList = activitiesMap['caseActivityStatus']['data'];

    activities =
        activityList.map((doc) => SmartActivityStatus.fromJson(doc)).toList();

    await FileApi.fetchAll();
  }

  _onTapSearchedActivity(SmartActivityStatus value) {
    setState(() {
      activity = value;
    });
  }

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
      _loadContacts();
    });
  }

  _submitFormData() {
    SmartEvent smartEvent = SmartEvent(
        title: activity!.getName(),
        description: descriptionController.text.trim(),
        startDate:
            DateFormat('dd/MM/yyyy').parse(startDateController.text.trim()),
        startTime: DateFormat('h:mm a').parse(startTimeController.text.trim()),
        endDate: DateFormat('dd/MM/yyyy').parse(endDateController.text.trim()),
        endTime: DateFormat('h:mm a').parse(endTimeController.text.trim()),
        employeeId: currentUser.id,
        caseActivityStatusId: activity!.id!,
        calendarEventTypeId: 1,
        externalTypeId: file!.id,
        firmEvent: 'yes',
        notifyOnDate:
            DateFormat('dd/MM/yyyy').parse(reminderDateController.text.trim()),
        notifyOnTime:
            DateFormat('h:mm a').parse(reminderTimeController.text.trim()),
        employeeIds: employeeIds,
        toBeNotified: emails);

    (widget.event == null)
        ? SmartCaseApi.smartPost(
            'api/calendar', currentUser.token, smartEvent.toJson(),
            onError: () {
            Fluttertoast.showToast(
                msg: "An error occurred",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
                fontSize: 16.0);
          }, onSuccess: () {
            Fluttertoast.showToast(
                msg: "Event added successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
                fontSize: 16.0);
          })
        : SmartCaseApi.smartPut('api/calendar/${widget.event!.id}',
            currentUser.token, smartEvent.toJson(), onError: () {
            Fluttertoast.showToast(
                msg: "An error occurred",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
                fontSize: 16.0);
          }, onSuccess: () {
            Fluttertoast.showToast(
                msg: "Event updated successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
                fontSize: 16.0);
          });

    Navigator.pop(context);
  }

  _loadEmployees() async {
    Map employeesMap =
        await SmartCaseApi.smartFetch('api/hr/employees', currentUser.token);

    List employees = employeesMap["search"]["employees"];

    this.employees = employees.map((doc) => SmartUser.fromJson(doc)).toList();
  }

  _fillDataForUpdate() {
    if (widget.event != null) {
      // To be uncommented after smart file class rewrite.
      activity = widget.activity!;
      descriptionController.text = widget.event!.description!;
      startDateController.text =
          DateFormat('dd/MM/yyyy').format(widget.event!.startDate!);
      endDateController.text =
          DateFormat('dd/MM/yyyy').format(widget.event!.endDate!);
      startTimeController.text =
          DateFormat('h:mm a').format(widget.event!.startTime!);
      endTimeController.text =
          DateFormat('h:mm a').format(widget.event!.endTime!);
      reminderDateController.text =
          DateFormat('dd/MM/yyyy').format(widget.event!.notifyOnDate!);
      reminderTimeController.text =
          DateFormat('h:mm a').format(widget.event!.notifyOnTime!);
      employeeIds = widget.event!.employeeIds!;
      file = widget.event!.file!;
      // emails = widget.file!.toBeNotified!;
    }
  }
}
