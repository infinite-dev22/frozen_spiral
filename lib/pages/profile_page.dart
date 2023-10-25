import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/profile/profile_detail_item.dart';
import 'package:smart_case/widgets/profile/profile_master_item.dart';
import 'package:smart_case/widgets/wide_button.dart';

import '../widgets/custom_accordion.dart';
import '../widgets/custom_dropdowns.dart';

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
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController personalEmailController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController socialSecurityNumberController =
      TextEditingController();
  TextEditingController tinNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUserImage != null ? true : false,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProfileMasterItem(
          image: currentUserImage,
          isFile: false,
          isNetwork: currentUserImage != null ? true : false,
          color: Colors.white,
          padding: 20,
          changePhotoTap: _changePhotoTapped,
          changePasswordTap: _changePasswordTapped,
          firstName: currentUser.firstName ?? 'Null',
          lastName: currentUser.lastName ?? 'Null',
        ),
        const SizedBox(
          height: 20,
        ),
        ProfileDetailItem(
          gender: (currentUser.gender == 1) ? 'Male' : 'Female',
          email: currentUser.personalEmail ?? 'Null',
          personalEmail: currentUser.personalEmail ?? 'Null',
          telephone: currentUser.telephone ?? 'Null',
          dateOfBirth: currentUser.dateOfBirth,
          height: currentUser.height,
          code: currentUser.code,
          idNumber: currentUser.idNumber,
          nssfNumber: currentUser.nssfNumber,
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
          SmartCaseTextField(
            hint: 'First name',
            controller: firstNameController,
          ),
          SmartCaseTextField(
            hint: 'Last name',
            controller: lastNameController,
          ),
          SmartCaseTextField(
            hint: 'Other name',
            controller: otherNameController,
          ),
          GenderDropdown(onChanged: (value) {
            genderController.text = value.toString();
          }),
          DOBAccordion(
            dateController: dateOfBirthController,
            hint: 'Date of birth',
          ),
          SmartCaseTextField(
            hint: 'Personal email',
            controller: personalEmailController,
          ),
          SmartCaseTextField(
            hint: 'Telephone',
            controller: telephoneController,
          ),
          SmartCaseTextField(
            hint: 'Social Security Number',
            controller: socialSecurityNumberController,
          ),
          SmartCaseTextField(
            hint: 'Tin number',
            controller: tinNumberController,
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }

  _setUpProfileDetails() {
    firstNameController.text = currentUser.firstName ?? '';
    lastNameController.text = currentUser.lastName ?? '';
    otherNameController.text = currentUser.middleName ?? '';
    genderController.text = (currentUser.gender == 1) ? 'Male' : 'Female';
    dateOfBirthController.text = currentUser.dateOfBirth ?? '';
    personalEmailController.text = currentUser.personalEmail ?? '';
    telephoneController.text = currentUser.telephone ?? '';
    socialSecurityNumberController.text = currentUser.nssfNumber ?? '';
    tinNumberController.text = currentUser.tinNumber ?? '';
  }

  @override
  void initState() {
    _setUpProfileDetails();

    super.initState();
  }
}
