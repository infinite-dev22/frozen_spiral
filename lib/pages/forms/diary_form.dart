import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

import '../../data/data.dart';
import '../../widgets/custom_accordion.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_textbox.dart';

class DiaryForm extends StatefulWidget {
  const DiaryForm({super.key});

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
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
        child:  ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                children: [
                  DateTimeAccordion(
                    name: 'Starts on',
                  ),
                  Divider(indent: 5, endIndent: 5),
                  DateTimeAccordion(name: 'Ends on'),
                ],
              ),
            ),
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
            const DateTimeAccordion(
              name: 'Set reminder',
            ),
            CustomDropdown(
              hint: 'Reminder method',
              list: activityList,
              onChanged: (value) {},
            ),
            CustomTextArea(
                hint: 'Description', controller: descriptionController),
          ],
        ),
      ),
    );
  }

  _buildEditTextFormField(String hint, TextEditingController controller) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textBoxColor,
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.inActiveColor),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
