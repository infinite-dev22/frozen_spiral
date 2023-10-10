import 'package:flutter/material.dart';
import 'package:smart_case/widgets/activity_item.dart';

import '../data/data.dart';
import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(
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
          name: activities[index]['name'],
          date: activities[index]['date'],
          doneBy: activities[index]['doneBy'],
          padding: 20,
          color: Colors.white,
        );
      },
    );
  }
}
