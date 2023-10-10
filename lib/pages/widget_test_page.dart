import 'package:flutter/material.dart';
import 'package:smart_case/widgets/activity_item.dart';
import 'package:smart_case/widgets/file/file_item.dart';
import 'package:smart_case/widgets/module_item.dart';

import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class WidgetTestPage extends StatefulWidget {
  const WidgetTestPage({super.key, required this.title});

  final String title;

  @override
  State<WidgetTestPage> createState() => _WidgetTestPageState();
}

class _WidgetTestPageState extends State<WidgetTestPage> {
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
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ModuleItem(
            name: 'name',
            color: Colors.white,
            padding: 20,
            icon: Icons.transfer_within_a_station),
        SizedBox(
          height: 20,
        ),
        FileItem(
          fileName: 'Test data name',
          fileNumber: 'Test/data/file/number',
          dateCreated: 'Test/data/date',
          clientName: 'Test data name',
          color: Colors.white,
          padding: 20,
        ),
        SizedBox(
          height: 20,
        ),
        ActivityItem(
          name: 'Test',
          color: Colors.white,
          padding: 20,
        ),
      ],
    );
  }
}
