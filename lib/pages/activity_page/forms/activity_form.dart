import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/database/contact/contact_model.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_searchable_async_bottom_sheet_contents.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, this.activity});

  final SmartActivity? activity;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final globalKey = GlobalKey();
  bool isTitleElevated = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  List emails = List.empty(growable: true);

  final ValueNotifier<SmartActivityStatus?> activitySelectedValue =
      ValueNotifier<SmartActivityStatus?>(null);
  final ValueNotifier<SmartFile?> fileSelectedValue =
      ValueNotifier<SmartFile?>(null);

  List<SmartActivityStatus> activities = List.empty(growable: true);
  List<SmartContact> contacts = List.empty(growable: true);

  SmartActivityStatus? activity;
  SmartFile? file;
  String? billable = 'yes';

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
            name: '${(widget.activity == null) ? 'New' : 'Edit'} Activity',
            addButtonText: (widget.activity == null) ? 'Add' : 'Update',
            isElevated: isTitleElevated,
            onSave: () => _submitForm(),
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
                  padding: const EdgeInsets.all(8),
                  children: [
                    LayoutBuilder(builder: (context, constraints) {
                      return Form(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _showSearchFileBottomSheet,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.centerLeft,
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
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
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
                            ActivityDateTimeAccordion(
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
                            if (file != null && contacts.isNotEmpty)
                              MultiSelectDropDown(
                                clearIcon: const Icon(FontAwesome.xmark_solid),
                                hint: 'Client to notify',
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
        defaultSelected: billable ?? 'yes',
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
              return AsyncSearchableBottomSheetContents(
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

                    setState(() {});
                  }
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
                  Navigator.pop(context);
                  _onTapSearchedActivity(value!);
                },
                onSearch: (value) {
                  searchedList.clear();
                  if (value.length > 2) {
                    if (activities.isNotEmpty) {
                      isLoading = false;
                      searchedList.addAll(activities.where((activity) =>
                          activity.name!
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

    if (mounted) {
      setState(() {
        this.contacts =
            contacts!.map((doc) => SmartContact.fromJson(doc)).toList();
        contacts = null;
      });
    }
  }

  @override
  void initState() {
    _setUpData();
    _fillInFormDataForEdit();

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

  _fillInFormDataForEdit() {
    if (widget.activity != null) {
      file = widget.activity?.file;
      activity = widget.activity?.caseActivityStatus;

      if (widget.activity!.billable == 1) {
        billable = 'yes';
      } else if (widget.activity!.billable == 0) {
        billable = 'no';
      }

      descriptionController.text = widget.activity!.description!;
      dateController.text = widget.activity!.date != null
          ? DateFormat('dd/MM/yyyy').format(widget.activity!.date!)
          : '';
      startTimeController.text = widget.activity!.startTime != null
          ? DateFormat('h:mm a').format(widget.activity!.startTime!)
          : "";
      endTimeController.text = widget.activity!.endTime != null
          ? DateFormat('h:mm a').format(widget.activity!.endTime!)
          : "";
      _loadContacts();
    }
  }

  _submitForm() {
    SmartActivity smartActivity = SmartActivity(
        description: descriptionController.text.trim(),
        caseActivityStatusId: activity!.id,
        employeeId: currentUser.id,
        date: DateFormat('dd/MM/yyyy').parse(dateController.text.trim()),
        billable: billable,
        startTime: DateFormat('h:mm a').parse(startTimeController.text.trim()),
        endTime: DateFormat('h:mm a').parse(endTimeController.text.trim()),
        emails: emails,
        file: file);

    // print(widget.activity!.id);
    // print(jsonEncode(SmartActivity.toActivityCreateJson(smartActivity)));

    (widget.activity == null)
        ? SmartCaseApi.smartPost(
            'api/cases/${file!.id}/activities',
            currentUser.token,
            SmartActivity.toActivityCreateJson(smartActivity), onError: () {
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
                msg: "Activity added successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
                fontSize: 16.0);
          })
        : SmartCaseApi.smartPut(
            'api/cases/${file!.id}/activities/${widget.activity!.id}',
            currentUser.token,
            SmartActivity.toActivityCreateJson(smartActivity), onError: () {
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
                msg: "Activity updated successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
                fontSize: 16.0);
          });

    Navigator.pop(context);
  }
}
