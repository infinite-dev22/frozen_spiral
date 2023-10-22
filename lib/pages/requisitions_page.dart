import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';

import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class RequisitionsPage extends StatefulWidget {
  const RequisitionsPage({super.key});

  @override
  State<RequisitionsPage> createState() => _RequisitionsPageState();
}

class _RequisitionsPageState extends State<RequisitionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          searchable: true,
          filterable: true,
          search: 'requisitions',
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return const Center(
      child: Text(
        'Your requisitions appear here',
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
