import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_dropdown.dart';

import 'package:smart_case/data/data.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm(
      {super.key,
      required this.dateOfBirthController,
      required this.descriptionController,
      this.onSave,
      this.onActivityChange,
      this.onFileChange,
      required this.activitySearchController,
      required this.fileSearchController});

  final TextEditingController dateOfBirthController;
  final TextEditingController descriptionController;
  final TextEditingController activitySearchController;
  final TextEditingController fileSearchController;

  final Function(String?)? onSave;
  final Function(String?)? onActivityChange;
  final Function(String?)? onFileChange;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  List filteredActivityList = List.empty(growable: true);
  List filteredFileList = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    List defaultList = [''];
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            child: Column(
              children: [
                CustomDropdown(
                  placeHolder: 'Select activity',
                  list: filteredActivityList.isNotEmpty
                      ? filteredActivityList
                      : defaultList,
                  onChanged: widget.onActivityChange,
                  onSearch: (value) {
                    // Code only to imitate like functionality.
                    if (value!.length > 2) {
                      setState(() {
                        filteredActivityList = activityList
                            .where((element) => element == value)
                            .toList();
                      });
                    } else {
                      print('Enter at least 3 digits');
                    }
                  },
                  // searchController: activitySearchController,
                ),
                CustomDropdown(
                  placeHolder: 'Select file',
                  list: filteredFileList.isNotEmpty
                      ? filteredFileList
                      : defaultList,
                  onChanged: widget.onFileChange,
                  onSearch: (value) {
                    // Code only to imitate like functionality.
                    if (value!.length > 2) {
                      setState(() {
                        filteredFileList = activityList
                            .where((element) => element == value)
                            .toList();
                        defaultList = filteredFileList;
                      });
                    } else {
                      print('Enter at least 3 digits');
                    }
                  },
                  // searchController: fileSearchController,
                ),
                _buildEditTextFormField(
                    'Time here', widget.dateOfBirthController),
                _buildGroupedRadios(),
                CustomTextArea(
                    hint: 'Description',
                    controller: widget.descriptionController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildEditTextFormField(String hint, TextEditingController controller) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.textBoxColor,
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.inActiveColor, fontSize: 15),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _buildGroupedRadios() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 20),
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
        width: 150,
        absoluteZeroSpacing: false,
        selectedColor: AppColors.primary,
        padding: 5,
        radius: 20,
        enableShape: true,
      ),
    );
  }
}
