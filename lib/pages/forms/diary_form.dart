import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:smart_case/models/smart_event.dart';
import 'package:smart_case/models/user.dart';
import 'package:smart_case/theme/color.dart';
import 'package:toast/toast.dart';

import '../../models/smart_activity.dart';
import '../../models/smart_contact.dart';
import '../../models/smart_file.dart';
import '../../services/apis/smartcase_api.dart';
import '../../util/smart_case_init.dart';
import '../../widgets/custom_accordion.dart';
import '../../widgets/custom_searchable_async_activity_bottom_sheet_contents.dart';
import '../../widgets/custom_searchable_async_file_bottom_sheet_contents.dart';
import '../../widgets/custom_textbox.dart';
import '../../widgets/form_title.dart';

class DiaryForm extends StatefulWidget {
  const DiaryForm({super.key});

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  final globalKey = GlobalKey();
  final ToastContext toast = ToastContext();
  bool isTitleElevated = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController reminderDateController = TextEditingController();
  final TextEditingController reminderTimeController = TextEditingController();
  List emails = List.empty(growable: true);
  List<String> employeeIds = List.empty(growable: true);

  final ValueNotifier<SmartActivity?> activitySelectedValue =
      ValueNotifier<SmartActivity?>(null);
  final ValueNotifier<SmartFile?> fileSelectedValue =
      ValueNotifier<SmartFile?>(null);

  List<SmartActivityStatus> activities = List.empty(growable: true);
  List<SmartFile> files = List.empty(growable: true);
  List<SmartContact> contacts = List.empty(growable: true);
  List<SmartUser> employees = List.empty(growable: true);

  SmartActivityStatus? activity;
  SmartFile? file;

  @override
  Widget build(BuildContext context) {
    toast.init(context);

    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Column(
      children: [
        FormTitle(
          name: 'New Calendar Event',
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
                padding: const EdgeInsets.all(16),
                children: [
                  DoubleDateTimeAccordion(
                      startName: 'Starts on',
                      endName: 'Ends on',
                      startDateController: startDateController,
                      startTimeController: startTimeController,
                      endDateController: endDateController,
                      endTimeController: endTimeController),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _showSearchFileBottomSheet,
                      child: Text(
                        file?.fileName ?? 'Select file',
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: _showSearchActivityBottomSheet,
                      child: Text(
                        activity?.name ?? 'Select activity status',
                      ),
                    ),
                  ),
                  if (file != null)
                    Column(
                      children: [
                        MultiSelectDropDown(
                          showClearIcon: true,
                          hint: 'Select contact to notify',
                          onOptionSelected: (options) {
                            for (var element in options) {
                              emails.add(element.value!);
                            }
                          },
                          options: contacts
                              .map((contact) => ValueItem(
                                  label: '${contact.name} - ${contact.email}',
                                  value: '${contact.name}|${contact.email}'))
                              .toList(),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                          dropdownHeight: 300,
                          borderColor: AppColors.white,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionIcon: const Icon(Icons.check_circle),
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
                          showClearIcon: true,
                          dropdownHeight: 300,
                          onOptionSelected: (options) {
                            for (var element in options) {
                              employeeIds.add(element.value!);
                            }
                          },
                          options: employees
                              .map((employee) => ValueItem(
                                  label: employee.getName(),
                                  value: employee.id.toString()))
                              .toList(),
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                          borderColor: AppColors.white,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionIcon: const Icon(Icons.check_circle),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  CustomTextArea(
                    key: globalKey,
                    hint: 'Description',
                    controller: descriptionController,
                    onTap: () {
                      Scrollable.ensureVisible(globalKey.currentContext!);
                    },
                  ),
                  const SizedBox(
                      height:
                          300 /* MediaQuery.of(context).viewInsets.bottom */),
                ],
              ),
            ),
          ),
        ),
      ],
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
              return AsyncSearchableSmartFileBottomSheetContents(
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
                      if (files.isNotEmpty) {
                        isLoading = false;
                        searchedList.addAll(files.where((smartFile) => smartFile
                            .fileName!
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
              return AsyncSearchableActivityBottomSheetContents(
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
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
    setState(() {});
  }

  _loadContacts() async {
    Map contactsMap = await SmartCaseApi.smartFetch(
        'api/cases/${file!.id}/contactsandfinancialstatus', currentUser.token);

    List? contacts = contactsMap['contacts'];
    setState(() {
      this.contacts =
          contacts!.map((doc) => SmartContact.fromJson(doc)).toList();
      contacts = null;
    });
  }

  @override
  void initState() {
    _setUpData();
    _loadEmployees();

    super.initState();
  }

  Future<void> _setUpData() async {
    Map activitiesMap = await SmartCaseApi.smartFetch(
        'api/admin/caseActivityStatus', currentUser.token);
    List activityList = activitiesMap['caseActivityStatus']['data'];

    activities =
        activityList.map((doc) => SmartActivityStatus.fromJson(doc)).toList();

    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
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
        externalTypeId: 1,
        firmEvent: 'yes',
        notifyOnDate:
            DateFormat('dd/MM/yyyy').parse(reminderDateController.text.trim()),
        notifyOnTime:
            DateFormat('h:mm a').parse(reminderTimeController.text.trim()),
        employeeIds: employeeIds,
        toBeNotified: emails);

    SmartCaseApi.smartPost(
        'api/calendar', currentUser.token, smartEvent.toJson(), onError: () {
      Toast.show("An error occurred",
          duration: Toast.lengthLong, gravity: Toast.bottom);
    }, onSuccess: () {
      Toast.show("Event added successfully",
          duration: Toast.lengthLong, gravity: Toast.bottom);
      Navigator.pop(context);
    });
  }

  _loadEmployees() async {
    Map employeesMap =
        await SmartCaseApi.smartFetch('api/hr/employees', currentUser.token);

    List employees = employeesMap["search"]["employees"];

    this.employees = employees.map((doc) => SmartUser.fromJson(doc)).toList();
  }
}
