import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/wide_button.dart';

class ActivityForm extends StatelessWidget {
  const ActivityForm(
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
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          _buildBottomSheetTitle('Edit your details', context),
          const SizedBox(
            height: 20,
          ),
          _buildEditBottomSheetForm(),
        ],
      ),
    );
  }

  _buildBottomSheetTitle(String name, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.red,
              fontSize: 16,
            ),
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        TextButton(
          onPressed: onSave,
          child: const Text(
            'Save',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  _buildEditBottomSheetForm() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEditTextFormField('First name', firstNameController),
          _buildEditTextFormField('Last name', lastNameController),
          _buildEditTextFormField('Other name', otherNameController),
          _buildEditTextFormField('Gender', genderController),
          _buildEditTextFormField('Title', titleController),
          _buildEditTextFormField('Date of birth', dateOfBirthController),
          _buildEditTextFormField('Personal email', personalEmailController),
          _buildEditTextFormField('Telephone', telephoneController),
          _buildEditTextFormField(
              'Social Security Number', socialSecurityNumberController),
          _buildEditTextFormField('Tin number', tinNumberController),
          _buildEditTextFormField('Role', roleController),
          WideButton(
            name: 'Save',
            onPressed: () => print('Activity form submitted.'),
          ),
        ],
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
