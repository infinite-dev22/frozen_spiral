import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_case/theme/color.dart';

import '../../widgets/form_title.dart';

class EngagementForm extends StatefulWidget {
  const EngagementForm(
      {super.key,
      required this.firstNameController,
      required this.lastNameController,
      required this.otherNameController,
      required this.genderController,
      required this.titleController,
      required this.dateOfBirthController,
      required this.personalEmailController,
      required this.telephoneController,
      required this.socialSecurityNumberController,
      required this.tinNumberController,
      required this.roleController,
      this.onSave});

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController otherNameController;
  final TextEditingController genderController;
  final TextEditingController titleController;
  final TextEditingController dateOfBirthController;
  final TextEditingController personalEmailController;
  final TextEditingController telephoneController;
  final TextEditingController socialSecurityNumberController;
  final TextEditingController tinNumberController;
  final TextEditingController roleController;

  final Function()? onSave;

  @override
  State<EngagementForm> createState() => _EngagementFormState();
}

class _EngagementFormState extends State<EngagementForm> {
  bool isTitleElevated = false;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Column(
      children: [
        FormTitle(
          name: 'New Engagement',
          onSave: () {},
          isElevated: isTitleElevated,
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
                  _buildEditTextFormField(
                      'First name', widget.firstNameController),
                  _buildEditTextFormField(
                      'Last name', widget.lastNameController),
                  _buildEditTextFormField(
                      'Other name', widget.otherNameController),
                  _buildEditTextFormField('Gender', widget.genderController),
                  _buildEditTextFormField('Title', widget.titleController),
                  _buildEditTextFormField(
                      'Date of birth', widget.dateOfBirthController),
                  _buildEditTextFormField(
                      'Personal email', widget.personalEmailController),
                  _buildEditTextFormField(
                      'Telephone', widget.telephoneController),
                  _buildEditTextFormField('Social Security Number',
                      widget.socialSecurityNumberController),
                  _buildEditTextFormField(
                      'Tin number', widget.tinNumberController),
                  _buildEditTextFormField('Role', widget.roleController),
                ],
              ),
            ),
          ),
        ),
      ],
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
