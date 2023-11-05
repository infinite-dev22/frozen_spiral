import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:full_picker/full_picker.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/profile_widget/profile_detail_item.dart';
import 'package:smart_case/widgets/profile_widget/profile_master_item.dart';
import 'package:smart_case/widgets/wide_button.dart';
import 'package:toast/toast.dart';

import '../widgets/custom_accordion.dart';
import '../widgets/custom_dropdowns.dart';
import '../widgets/form_title.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ToastContext toast = ToastContext();
  bool isTitleElevated = false;

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
    toast.init(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          canNavigate: true,
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
    return FullPicker(
      context: context,
      prefixName: "Profile Photo",
      file: false,
      image: true,
      video: false,
      videoCamera: false,
      imageCamera: true,
      voiceRecorder: false,
      videoCompressor: false,
      imageCropper: true,
      multiFile: false,
      url: false,
      onError: (int value) {
        if (kDebugMode) {
          print(" ----  onError ----=$value");
        }
      },
      onSelected: (value) {
        SmartCaseApi.uploadProfilePicture(value.file.first!, onError: () {
          Toast.show("An error occurred",
              duration: Toast.lengthLong, gravity: Toast.bottom);
        }, onSuccess: () {
          Toast.show("Profile photo updated successfully",
              duration: Toast.lengthLong, gravity: Toast.bottom);
        });
      },
    );
  }

  _changePasswordTapped() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => _buildChangePasswordBottomSheetForm(),
    );
  }

  _buildChangePasswordBottomSheetForm() {
    return Column(
      children: [
        FormTitle(
          name: 'Change Password',
          onSave: () {},
        ),
        Padding(
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
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  _changeEditDetailsTapped() {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => _buildEditBottomSheetForm(),
    );
  }

  _buildEditBottomSheetForm() {
    final ScrollController scrollController = ScrollController();

    return Column(
      children: [
        FormTitle(
          name: 'Edit your details',
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
            ),
          ),
        ),
      ],
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
