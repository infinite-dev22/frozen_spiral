import 'dart:io';

import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/form_title.dart';

import '../widgets/bottom_bar_item.dart';
import 'activities_page.dart';
import 'files_page.dart';
import 'forms/activity_form.dart';
import 'forms/diary_form.dart';
import 'forms/engagements_form.dart';
import 'forms/requisition_form.dart';
import 'forms/task_form.dart';
import 'home_page.dart';
import 'locator_page.dart';
import 'notifications_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _activeTab = 0;

  final TextEditingController activitySearchController =
      TextEditingController();
  final TextEditingController fileSearchController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController otherNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController personalEmailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController socialSecurityNumberController =
      TextEditingController();
  final TextEditingController tinNumberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  _barItems() {
    return [
      {
        "icon": Icons.home_outlined,
        "active_icon": Icons.home_rounded,
        "name": "Home",
        "page": const HomePage(),
      },
      {
        "icon": Icons.file_copy_outlined,
        "active_icon": Icons.file_copy_rounded,
        "name": "Files",
        "page": const FilesPage(),
      },
      {
        "icon": Icons.local_activity_outlined,
        "active_icon": Icons.local_activity_rounded,
        "name": "Activities",
        "page": const ActivitiesPage(),
      },
      {
        "icon": Icons.notifications_none_rounded,
        "active_icon": Icons.notifications_rounded,
        "name": "Alerts",
        "page": const AlertsPage(),
      },
      {
        "icon": Icons.location_on_outlined,
        "active_icon": Icons.location_on_rounded,
        "name": "Locator",
        "page": const LocatorPage(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      body: DoubleBack(
        message: 'Tap back again to exit',
        child: _buildPage(),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _buildFab(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  _buildFab() {
    return ExpandableFab(
      type: ExpandableFabType.up,
      duration: const Duration(milliseconds: 500),
      distance: 65.0,
      childrenOffset: const Offset(0, 20),
      overlayStyle: ExpandableFabOverlayStyle(
        // color: Colors.black.withOpacity(0.5),
        blur: 5,
      ),
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.add),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        angle: 3.14 * 2,
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
      ),
      children: [
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.handshake_outlined),
          onPressed: _buildEngagementForm,
          label: const Text("Engagement"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.list_rounded),
          onPressed: _buildRequisitionForm,
          label: const Text("Requisition"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.local_activity_outlined),
          onPressed: _buildActivityForm,
          label: const Text("Activity"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.task_outlined),
          onPressed: _buildTaskForm,
          label: const Text("Task"),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.calendar_month_rounded),
          onPressed: _buildDairyForm,
          label: const Text("Diary"),
        ),
      ],
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems().length,
        (index) => _barItems()[index]["page"],
      ),
    );
  }

  Widget _buildBottomBar() {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    return Container(
      height: (Platform.isIOS) ? 80 : screenHeight * .087,
      // formerly 80.
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          _barItems().length,
          (index) {
            if (index == 2) {
              return BottomBarItem(
                _activeTab == index
                    ? _barItems()[index]["active_icon"]
                    : _barItems()[index]["icon"],
                _barItems()[index]["name"],
                isActive: _activeTab == index,
                activeColor: AppColors.primary,
                onTap: () {
                  setState(() {
                    _activeTab = index;
                  });
                },
              );
            } else {
              return BottomBarItem(
                _activeTab == index
                    ? _barItems()[index]["active_icon"]
                    : _barItems()[index]["icon"],
                _barItems()[index]["name"],
                isActive: _activeTab == index,
                activeColor: AppColors.primary,
                onTap: () {
                  setState(() {
                    _activeTab = index;
                  });
                },
              );
            }
          },
        ),
      ),
    );
  }

  _buildActivityForm() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      backgroundColor: AppColors.appBgColor,
      builder: (context) => Column(
        children: [
          FormTitle(
            name: 'New Activity',
            onSave: () {},
          ),
          const ActivityForm(),
        ],
      ),
    );
  }

  _buildRequisitionForm() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          FormTitle(
            name: 'New Requisition',
            onSave: () {},
          ),
          const RequisitionForm(),
        ],
      ),
    );
  }

  _buildTaskForm() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          FormTitle(
            name: 'New Task',
            onSave: () {},
          ),
          const TaskForm(),
        ],
      ),
    );
  }

  _buildDairyForm() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          FormTitle(
            name: 'New Calendar Event',
            onSave: () {},
          ),
          const DiaryForm(),
        ],
      ),
    );
  }

  _buildEngagementForm() {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => Column(
        children: [
          FormTitle(
            name: 'New Engagement',
            onSave: () {},
          ),
          EngagementForm(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            otherNameController: otherNameController,
            genderController: genderController,
            titleController: titleController,
            dateOfBirthController: dateOfBirthController,
            personalEmailController: personalEmailController,
            telephoneController: telephoneController,
            socialSecurityNumberController: socialSecurityNumberController,
            tinNumberController: tinNumberController,
            roleController: roleController,
          ),
        ],
      ),
    );
  }
}
