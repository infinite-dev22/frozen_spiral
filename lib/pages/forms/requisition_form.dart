import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/data.dart';
import 'package:smart_case/widgets/custom_accodion.dart';
import 'package:smart_case/widgets/custom_dropdown.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

class RequisitionForm extends StatefulWidget {
  const RequisitionForm({
    super.key,
    this.onSave,
  });

  final Function()? onSave;

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  late String date;

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
            DateAccordion(
              onDateChanged: (DateTime value) {
                date = DateFormat('dd/MM/yyyy').format(value);
              },
            ),
            CustomDropdown(list: activityList, hint: 'Currency'),
            CustomDropdown(list: activityList, hint: 'File'),
            CustomDropdown(list: activityList, hint: 'Approver'),
            CustomDropdown(list: activityList, hint: 'Category'),
            SmartCaseTextField(hint: 'Amount', controller: amountController),
            CustomTextArea(
                hint: 'Description', controller: descriptionController),
          ],
        ),
      ),
    );
  }
}
