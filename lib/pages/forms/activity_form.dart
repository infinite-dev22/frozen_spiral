import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:smart_case/models/smart_contact.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:toast/toast.dart';

import '../../models/smart_activity.dart';
import '../../models/smart_file.dart';
import '../../services/apis/smartcase_api.dart';
import '../../util/smart_case_init.dart';
import '../../widgets/custom_searchable_async_activity_bottom_sheet_contents.dart';
import '../../widgets/custom_searchable_async_file_bottom_sheet_contents.dart';
import '../../widgets/form_title.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final globalKey = GlobalKey();
  final ToastContext toast = ToastContext();
  bool isTitleElevated = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  List emails = List.empty(growable: true);

  final ValueNotifier<SmartActivity?> activitySelectedValue =
      ValueNotifier<SmartActivity?>(null);
  final ValueNotifier<SmartFile?> fileSelectedValue =
      ValueNotifier<SmartFile?>(null);

  List<SmartActivity> activities = List.empty(growable: true);
  List<SmartFile> files = List.empty(growable: true);
  List<SmartContact> contacts = List.empty(growable: true);

  SmartActivity? activity;
  SmartFile? file;
  String billable = 'yes';

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Expanded(
      child: Column(
        children: [
          FormTitle(
            name: 'New Activity',
            isElevated: isTitleElevated,
            onSave: () {
              SmartCaseApi.smartPost(
                  'api/cases/${file!.id}/activities', currentUser.token, {
                "description": descriptionController.text.trim(),
                "case_activity_status_id": activity!.id,
                "employee_id": currentUser.id,
                "date": dateController.text.trim(),
                "billable": billable,
                "from": startTimeController.text.trim(),
                "to": endTimeController.text.trim(),
                "to_be_notified": emails,
              }, onError: () {
                Toast.show("An error occurred",
                    duration: Toast.lengthLong, gravity: Toast.bottom);
              }, onSuccess: () {
                Toast.show("Activity added successfully",
                    duration: Toast.lengthLong, gravity: Toast.bottom);
                Navigator.pop(context);
              });
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
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
                    Form(
                      child: Column(
                        children: [
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
                          DateTimeAccordion2(
                              dateController: dateController,
                              startTimeController: startTimeController,
                              endTimeController: endTimeController),
                          _buildGroupedRadios(),
                          CustomTextArea(
                            key: globalKey,
                            hint: 'Description',
                            controller: descriptionController,
                            onTap: () {
                              Scrollable.ensureVisible(
                                  globalKey.currentContext!);
                            },
                          ),
                          const SizedBox(height: 10),
                          if (file != null)
                            MultiSelectDropDown(
                              showClearIcon: true,
                              hint: 'Notify',
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
                              chipConfig:
                                  const ChipConfig(wrapType: WrapType.wrap),
                              borderColor: AppColors.white,
                              optionTextStyle: const TextStyle(fontSize: 16),
                              selectedOptionIcon:
                                  const Icon(Icons.check_circle),
                            ),
                          const SizedBox(
                              height:
                                  300 /* MediaQuery.of(context).viewInsets.bottom */),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildGroupedRadios() {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CustomRadioButton(
        buttonTextStyle: const ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: AppColors.darker,
            textStyle: TextStyle(fontSize: 16)),
        radioButtonValue: (value) {
          billable = value;
        },
        defaultSelected: 'yes',
        unSelectedColor: AppColors.white,
        buttonLables: const [
          "Billable",
          "Non-billable",
        ],
        buttonValues: const [
          'yes',
          'no',
        ],
        spacing: 0,
        horizontal: false,
        enableButtonWrap: false,
        width: screenWidth * .4,
        absoluteZeroSpacing: false,
        selectedColor: AppColors.primary,
        padding: 5,
        radius: 20,
        enableShape: true,
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
              return AsyncSearchableSmartFileBottomSheetContents(
                hint: "Search file",
                list: searchedList,
                onTap: (value) {
                  file = null;
                  _onTapSearchedFile(value!);
                  Navigator.pop(context);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (files.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(files.where((smartFile) => smartFile
                          .fileName
                          .toLowerCase()
                          .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadFiles();
                      isLoading = true;
                      setState(() {});
                    }
                  }
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _showSearchActivityBottomSheet() {
    List<SmartActivity> searchedList = List.empty(growable: true);
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
                  Navigator.pop(context);
                  _onTapSearchedActivity(value!);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (activities.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(activities.where((activity) =>
                          activity.name
                              .toLowerCase()
                              .contains(value.toLowerCase())));
                      setState(() {});
                    } else {
                      _reloadActivities();
                      isLoading = true;
                      setState(() {});
                    }
                  }
                },
                isLoading: isLoading,
              );
            },
          );
        });
  }

  _reloadActivities() async {
    activities = await SmartCaseApi.fetchAllActivities(currentUser.token);
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

    super.initState();
  }

  Future<void> _setUpData() async {
    activities = await SmartCaseApi.fetchAllActivities(currentUser.token);
    files = await SmartCaseApi.fetchAllFiles(currentUser.token);
    setState(() {});
  }

  _onTapSearchedActivity(SmartActivity value) {
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
}
