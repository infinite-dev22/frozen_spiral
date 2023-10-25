import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

import '../../widgets/form_title.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, this.onSave});

  final Function()? onSave;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  bool isTitleElevated = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();

    return Column(
      children: [
        FormTitle(
          name: 'New Task',
          onSave: () {},
          isElevated: isTitleElevated,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                  SmartCaseTextField(hint: 'Name', controller: nameController),
                  SmartCaseTextField(
                      hint: 'Amount', controller: amountController),
                  CustomTextArea(
                      hint: 'Description', controller: descriptionController),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
