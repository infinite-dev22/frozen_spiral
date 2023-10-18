import 'package:async_searchable_dropdown/async_searchable_dropdown.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../../models/activity.dart';
import '../../models/file.dart';
import '../../services/apis/smartcase_api.dart';
import '../../util/smart_case_init.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final TextEditingController descriptionController = TextEditingController();

  final ValueNotifier<Activity?> activitySelectedValue =
      ValueNotifier<Activity?>(null);
  final ValueNotifier<SmartFile?> fileSelectedValue =
      ValueNotifier<SmartFile?>(null);

  late List<Activity> activities;
  late List<SmartFile> files;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    print(activitySelectedValue.value.toString());
    return Expanded(
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            FocusManager.instance.primaryFocus?.unfocus();
            return true;
          }
          return false;
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Form(
              child: Column(
                children: [
                  _buildSearchableActivityDropdown(),
                  _buildSearchableFileDropdown(),
                  const DateTimeAccordion2(),
                  _buildGroupedRadios(),
                  CustomTextArea(
                      hint: 'Description', controller: descriptionController),
                ],
              ),
            ),
          ],
        ),
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
          print(value);
        },
        defaultSelected: 'Billable',
        unSelectedColor: AppColors.white,
        buttonLables: const [
          "Billable",
          "Non-billable",
        ],
        buttonValues: const [
          "Billable",
          "Non-billable",
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

  Future<List<SmartFile>> getFileData(String? search) async {
    List<SmartFile> list = List.empty(growable: true);
    List<SmartFile> searches = List.empty(growable: true);
    searches.clear();
    // if (Random().nextBool()) throw 'sdd';
    // await Future.delayed(const Duration(microseconds: 200));
    searches.addAll(files.where((e) => e.fileName.contains(search!)));

    print('List length: ${searches.length}');

    setState(() {
      if (searches.isNotEmpty) {
        list = searches;
      } else {
        list = [];
      }
    });
    return list;
  }

  _buildSearchableFileDropdown() {
    return Column(
      children: [
        ValueListenableBuilder<SmartFile?>(
          valueListenable: fileSelectedValue,
          builder: (context, value, child) {
            return SearchableDropdown<SmartFile>(
              value: value,
              dropDownListWidth: MediaQuery.of(context).size.width * .92,
              dropDownListHeight: 200,
              itemLabelFormatter: (value) {
                return value.fileName;
              },
              remoteItems: (value) =>
                  getFileData((value!.length > 2) ? value : ''),
              onChanged: (value) {
                fileSelectedValue.value = value;
              },
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textBoxColor,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'File',
                hintStyle: const TextStyle(
                    fontSize: 16, color: AppColors.inActiveColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              borderRadius: BorderRadius.circular(10),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<List<Activity>> getActivityData(String? search) async {
    List<Activity> list = List.empty(growable: true);
    List<Activity> searches = List.empty(growable: true);
    searches.clear();
    // if (Random().nextBool()) throw 'sdd';
    // await Future.delayed(const Duration(microseconds: 200));
    searches.addAll(activities.where((e) => e.name.contains(search!)));

    print('List length: ${searches.length}');

    setState(() {
      if (searches.isNotEmpty) {
        list = searches;
      } else {
        list = [];
      }
    });
    return list;
  }

  _buildSearchableActivityDropdown() {
    return Column(
      children: [
        ValueListenableBuilder<Activity?>(
          valueListenable: activitySelectedValue,
          builder: (context, value, child) {
            return SearchableDropdown<Activity>(
              value: value,
              dropDownListWidth: MediaQuery.of(context).size.width * .92,
              dropDownListHeight: 200,
              itemLabelFormatter: (value) {
                return value.name;
              },
              remoteItems: (value) =>
                  getActivityData((value!.length > 2) ? value : ''),
              onChanged: (value) {
                activitySelectedValue.value = value;
              },
              inputDecoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textBoxColor,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Activity',
                hintStyle: const TextStyle(
                    fontSize: 16, color: AppColors.inActiveColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              borderRadius: BorderRadius.circular(10),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
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
}
