import 'package:flutter/material.dart';
import 'package:smart_case/models/smart_activity.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/activity_item.dart';

import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  List<SmartActivity> activities = List.empty(growable: true);

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
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 10,
        top: 16,
        right: 10,
        bottom: 80,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ActivityItem(
          name: activities[index].name,
          date: activities[index].activityDate ?? 'Null',
          doneBy:
              '${currentUser.firstName} ${currentUser.middleName ?? ''} ${currentUser.lastName}',
          padding: 20,
          color: Colors.white,
        );
      },
    );
  }

  @override
  void initState() {
    _setUpData();

    super.initState();
  }

  Future<void> _setUpData() async {
    activities = await SmartCaseApi.fetchAllActivities(currentUser.token);
    setState(() {});
  }
}
