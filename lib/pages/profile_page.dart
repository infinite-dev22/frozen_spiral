import 'package:flutter/material.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/profile/profile_detail_item.dart';
import 'package:smart_case/widgets/profile/profile_master_item.dart';
import 'package:smart_case/widgets/wide_button.dart';

import '../data/data.dart';
import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController otherNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController personalEmailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController socialSecurityNumberController =
      TextEditingController();
  TextEditingController tinNumberController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileMasterItem(
          image: profile['picture'],
          isFile: false,
          isNetwork: false,
          color: Colors.white,
          padding: 20,
          changePhotoTap: _changePhotoTapped,
          changePasswordTap: _changePasswordTapped,
        ),
        const SizedBox(
          height: 20,
        ),
        ProfileDetailItem(
          gender: profile['gender'],
          email: profile['email'],
          personalEmail: profile['personal_email'],
          telephone: profile['telephone'],
          dateOfBirth: profile['dob'],
          height: profile['height'],
          code: profile['code'],
          idNumber: profile['id_number'],
          nssfNumber: profile['nssf_number'],
          color: Colors.white,
          padding: 20,
          onPressed: _changeEditDetailsTapped,
        ),
      ],
    );
  }

  _changePhotoTapped() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (context) => Column(
        children: [
          _buildBottomSheetTitle('Change Photo'),
          const SizedBox(
            height: 20,
          ),
          _buildChangePhotoBottomSheetButtons(),
        ],
      ),
    );
  }

  _buildBottomSheetTitle(String name) {
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
          onPressed: () {
            if (name.contains('Photo')) {
              print('User changed photo');
            }
            if (name.contains('Password')) {
              print('User Data:\n Old Password: ${oldPasswordController.text}'
                  '\n New Password: ${newPasswordController.text}'
                  '\n Confirm Password: ${confirmPasswordController.text}');
            }
            if (name.contains('details')) {
              print('User changed details');
            }
          },
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

  _buildChangePhotoBottomSheetButtons() {
    return const Column(
      children: [
        WideButton(name: 'Take Photo'),
        WideButton(name: 'Select Photo'),
      ],
    );
  }

  _changePasswordTapped() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          _buildBottomSheetTitle('Change Password'),
          const SizedBox(
            height: 20,
          ),
          _buildChangePasswordBottomSheetForm(),
        ],
      ),
    );
  }

  _buildChangePasswordBottomSheetForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AuthPasswordTextField(
              controller: oldPasswordController, hintText: 'Old password'),
          const SizedBox(
            height: 10,
          ),
          AuthPasswordTextField(
              controller: newPasswordController, hintText: 'New password'),
          const SizedBox(
            height: 10,
          ),
          AuthPasswordTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm password'),
          const SizedBox(
            height: 10,
          ),
          WideButton(
            name: 'Save',
            onPressed: () =>
                print('User Data:\n Old Password: ${oldPasswordController.text}'
                    '\n New Password: ${newPasswordController.text}'
                    '\n Confirm Password: ${confirmPasswordController.text}'),
          ),
        ],
      ),
    );
  }

  _changeEditDetailsTapped() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          _buildBottomSheetTitle('Edit your details'),
          const SizedBox(
            height: 20,
          ),
          _buildEditBottomSheetForm(),
        ],
      ),
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
            onPressed: () =>
                print('User Data:\n Old Password: ${oldPasswordController.text}'
                    '\n New Password: ${newPasswordController.text}'
                    '\n Confirm Password: ${confirmPasswordController.text}'),
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
