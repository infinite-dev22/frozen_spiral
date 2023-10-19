import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:toast/toast.dart';

import '../../models/activity.dart';
import '../../models/file.dart';
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

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  final ValueNotifier<Activity?> activitySelectedValue =
      ValueNotifier<Activity?>(null);
  final ValueNotifier<SmartFile?> fileSelectedValue =
      ValueNotifier<SmartFile?>(null);

  late List<Activity> activities;
  late List<SmartFile> files;

  Activity? activity;
  SmartFile? file;
  String billable = 'yes';

  @override
  Widget build(BuildContext context) {
    toast.init(context);
    return _buildBody();
  }

  _buildBody() {
    return Expanded(
      child: Column(
        children: [
          FormTitle(
            name: 'New Activity',
            onSave: () {
              print("Activity: ${activity!.id}\nFile: ${file!.id}"
                  "\nBillable: $billable\nDate: ${dateController.text}"
                  "\nStart Time: ${startTimeController.text}"
                  "\nEnd Time: ${endTimeController.text}"
                  "\nDescription: ${descriptionController.text}");

              SmartCaseApi.smartPost(currentUser.url,
                  'api/cases/${file!.id}/activities', currentUser.token, {
                "description": descriptionController.text.trim(),
                "case_activity_status_id": activity!.id,
                "employee_id": currentUser.id,
                "date": dateController.text.trim(),
                "billable": billable,
                "from": startTimeController.text.trim(),
                "to": endTimeController.text.trim(),
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
              child: ListView(
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
                            onPressed: _showSearchActivityBottomSheet,
                            child: Text(
                              activity?.name ?? 'Select activity status',
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
                            onPressed: _showSearchFileBottomSheet,
                            child: Text(
                              file?.fileName ?? 'Select file',
                            ),
                          ),
                        ),
                        DateTimeAccordion2(
                            date: dateController,
                            startTime: startTimeController,
                            endTime: endTimeController),
                        _buildGroupedRadios(),
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
                ],
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
                  Navigator.pop(context);
                  _onTapSearchedFile(value!);
                },
                onSearch: (value) {
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      searchedList.addAll(files.where((smartFile) => smartFile
                          .fileName
                          .toLowerCase()
                          .contains(value.toLowerCase())));
                    }
                  });
                },
              );
            },
          );
        });
  }

  _showSearchActivityBottomSheet() {
    List<Activity> searchedList = List.empty(growable: true);
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
                  setState(() {
                    searchedList.clear();
                    if (value.length > 2) {
                      searchedList.addAll(activities.where((activity) =>
                          activity.name
                              .toLowerCase()
                              .contains(value.toLowerCase())));
                    }
                  });
                },
              );
            },
          );
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

  _onTapSearchedActivity(Activity value) {
    setState(() {
      activity = value;
    });
  }

  _onTapSearchedFile(SmartFile value) {
    setState(() {
      file = value;
    });
  }
}
