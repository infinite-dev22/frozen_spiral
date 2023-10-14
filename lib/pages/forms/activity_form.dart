import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_accodion.dart';
import 'package:smart_case/widgets/custom_dropdown.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../../data/data.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm(
      {super.key});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
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
                  CustomDropdown(
                    hint: 'Search activity',
                    list: activityList,
                    onChanged: (value) {},
                  ),
                  CustomDropdown(
                    hint: 'Search file',
                    list: activityList,
                    onChanged: (value) {},
                  ),
                  const DateTimeAccordion(),
                  _buildGroupedRadios(),
                  CustomTextArea(
                      hint: 'Description',
                      controller: descriptionController),
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
}
