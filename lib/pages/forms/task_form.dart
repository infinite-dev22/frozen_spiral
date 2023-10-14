import 'package:flutter/material.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../../data/data.dart';
import '../../widgets/custom_dropdown.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.onSave});

  final Function()? onSave;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SmartCaseTextField(hint: 'Name', controller: nameController),
          CustomDropdown(list: activityList, hint: 'Priority'),
          CustomDropdown(list: activityList, hint: 'File'),
          CustomDropdown(list: activityList, hint: 'Approver'),
          CustomDropdown(list: activityList, hint: 'Category'),
          SmartCaseTextField(hint: 'Amount', controller: amountController),
          CustomTextArea(
              hint: 'Description', controller: descriptionController),
        ],
      ),
    );
  }
}
