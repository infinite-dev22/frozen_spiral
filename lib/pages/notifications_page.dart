import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUserImage != null ? true : false,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return const Center(
      child: Text(
        "Your notifications appear here",
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
