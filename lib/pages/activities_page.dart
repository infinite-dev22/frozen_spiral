import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_activity.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/activity_widget/activity_item.dart';

import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  TextEditingController filterController = TextEditingController();

  List<SmartActivity> activities = List.empty(growable: true);
  List<SmartActivity> filteredActivities = List.empty(growable: true);
  final List<String>? filters = [
    "Name",
    "File Name",
    "File Number",
    "File Number (Court)",
  ];

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
          searchable: true,
          filterable: true,
          search: 'activities',
          filterController: filterController,
          onChanged: _searchActivities,
          filters: filters,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return (filteredActivities.isEmpty)
        ? _buildNonSearchedBody()
        : _buildSearchedBody();
  }

  _buildNonSearchedBody() {
    return (activities.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return ActivityItem(
                activity: activities[index],
                padding: 20,
                color: Colors.white,
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  _buildSearchedBody() {
    return (filteredActivities.isNotEmpty)
        ? ListView.builder(
            padding: const EdgeInsets.only(
              left: 10,
              top: 16,
              right: 10,
              bottom: 80,
            ),
            itemCount: filteredActivities.length,
            itemBuilder: (context, index) {
              return ActivityItem(
                activity: filteredActivities[index],
                padding: 20,
                color: Colors.white,
              );
            },
          )
        : const Center(
            child: Text('No result found'),
          );
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }

  Future<void> _setUpData() async {
    activities = await SmartCaseApi.fetchAllActivities(currentUser.token);
    filterController.text == 'Name';
    setState(() {});
  }

  _searchActivities(String value) {
    filteredActivities.clear();
    if (filterController.text == 'File Name') {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.file!
              .getName()
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number') {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.fileNumber!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else if (filterController.text == 'File Number (Court)') {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.courtFileNumber!
              .toLowerCase()
              .contains(value.toLowerCase())));
      setState(() {});
    } else {
      filteredActivities.addAll(activities.where((smartActivity) =>
          smartActivity.getName().toLowerCase().contains(value.toLowerCase())));
      setState(() {});
    }
  }
}
