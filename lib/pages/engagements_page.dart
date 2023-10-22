import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../widgets/custom_appbar.dart';

class EngagementsPage extends StatefulWidget {
  const EngagementsPage({super.key});

  @override
  State<EngagementsPage> createState() => _EngagementsPageState();
}

class _EngagementsPageState extends State<EngagementsPage> {
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
          search: 'engagements',
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return const Center(
      child: Text(
        'Your engagements appear here',
        style: TextStyle(color: AppColors.inActiveColor),
      ),
    );
  }
}
