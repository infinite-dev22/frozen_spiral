import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_picker/full_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_case/database/password/password_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/password_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/auth_text_field.dart';
import 'package:smart_case/widgets/custom_accordion.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/form_title.dart';
import 'package:smart_case/widgets/profile_widget/profile_detail_item.dart';
import 'package:smart_case/widgets/profile_widget/profile_master_item.dart';

import '../services/apis/smartcase_apis/employee_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _detailFormKey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          canNavigate: true,
          isNetwork: currentUser.avatar != null ? true : false,
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
          image: currentUser.avatar,
          isFile: false,
          isNetwork: currentUser.avatar != null ? true : false,
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
      image: true,
      imageCamera: kDebugMode,
      imageCropper: true,
      onError: (int value) {
        if (kDebugMode) {
          print(" ---- onError ----=$value");
        }
      },
      onSelected: (value) {
        SmartCaseApi.uploadProfilePicture(value.file.first!, onError: () {
          setState(() {});
          Fluttertoast.showToast(
              msg: "An error occurred! Profile not updated",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
              fontSize: 16.0);
          // _buildImage();
        }, onSuccess: () {
          Fluttertoast.showToast(
              msg: "Profile photo updated successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppColors.green,
              textColor: AppColors.white,
              fontSize: 16.0);
          setState(() {});
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
          onSave: () => _onPasswordSubmit(),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _passwordFormKey,
            child: Column(
              children: [
                AuthPasswordTextField(
                    controller: oldPasswordController,
                    hintText: 'Old password'),
                const SizedBox(
                  height: 10,
                ),
                AuthPasswordTextField(
                    controller: newPasswordController,
                    hintText: 'New password'),
                const SizedBox(
                  height: 10,
                ),
                AuthPasswordTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm password'),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _onPasswordSubmit() {
    if (_passwordFormKey.currentState!.validate()) {
      if (newPasswordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        var password = Password(
            oldPassword: oldPasswordController.text.trim(),
            password: newPasswordController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim());

        Navigator.pop(context);

        PasswordApi.post(
          password,
          onSuccess: () {
            Fluttertoast.showToast(
                msg: "Password changed successfully",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: AppColors.green,
                textColor: AppColors.white,
                fontSize: 16.0);
          },
          onError: () => Fluttertoast.showToast(
              msg: "An error occurred",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
              fontSize: 16.0),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Passwords do not match",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
            fontSize: 16.0);
      }
    }
  }

  _onEmployeeDetailsSubmit() {
    if (_detailFormKey.currentState!.validate()) {
      var firstLetter = firstNameController.text;
      var middleLetter = otherNameController.text;
      var lastLetter = lastNameController.text;

      if (firstNameController.text.isNotEmpty) {
        firstLetter = firstLetter[0];
      }
      if (lastNameController.text.isNotEmpty) {
        lastLetter = lastLetter[0];
      }
      if (otherNameController.text.isNotEmpty) {
        middleLetter = middleLetter[0];
      }
      var employee = {
        "initials": "$firstLetter.$middleLetter.$lastLetter",
        "first_name": firstNameController.text,
        "middle_name": lastNameController.text,
        "last_name": otherNameController.text,
        "telephone": telephoneController.text,
        "date_of_birth": dateOfBirthController.text, // "21/01/1990",
        "gender":
            (genderController.text.toLowerCase().contains("female")) ? 0 : 1,
        "department_id": null,
        "code": null,
        "id_number": null,
        "nssf_number": socialSecurityNumberController.text,
        "tin_number": tinNumberController.text,
        "height": null,
        "blood_group": null,
        "personal_email": personalEmailController.text,
        "permanent_address": null,
        "present_address": null,
        "is_address_same": null,
        "office_number": null,
        "mobile_number": null,
        "salutation_id": 1,
        "marital_status_id": null
      };

      Navigator.pop(context);

      EmployeeApi.post(
        employee,
        currentUser.id,
        onSuccess: () {
          Fluttertoast.showToast(
              msg: "User details changed successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: AppColors.green,
              textColor: AppColors.white,
              fontSize: 16.0);
        },
        onError: () => Fluttertoast.showToast(
            msg: "An error occurred",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
            fontSize: 16.0),
      );
    }
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
          onSave: () => _onEmployeeDetailsSubmit(),
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
              child: Form(
                key: _detailFormKey,
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    SmartCaseTextField(
                      hint: 'First name',
                      controller: firstNameController,
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    SmartCaseTextField(
                      hint: 'Last name',
                      controller: lastNameController,
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    SmartCaseTextField(
                      hint: 'Other name',
                      controller: otherNameController,
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
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
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    SmartCaseTextField(
                      hint: 'Telephone',
                      controller: telephoneController,
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    SmartCaseTextField(
                      hint: 'Social Security Number',
                      controller: socialSecurityNumberController,
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    SmartCaseTextField(
                      hint: 'Tin number',
                      controller: tinNumberController,
                      maxLength: 60,
                      minLines: 1,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 300),
                  ],
                ),
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
    dateOfBirthController.text = (currentUser.dateOfBirth != null)
        ? DateFormat("dd/MM/yyyy")
            .format(DateTime.parse(currentUser.dateOfBirth))
        : '';
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
