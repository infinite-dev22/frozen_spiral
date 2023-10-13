import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class LocatorPage extends StatelessWidget {
  const LocatorPage({super.key});

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
        "Your locator appears here",
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
