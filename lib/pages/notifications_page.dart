import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
    return const Center(
      child: Text(
        "Your notifications appear here",
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
