import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_case/data/data.dart';
import 'package:smart_case/pages/profile_page.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/module_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(
            profile: () => Navigator.pushNamed(context, '/profile')),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of items in each row
        mainAxisSpacing: 20, // spacing between rows
        crossAxisSpacing: 20, // spacing between columns
      ),
      padding: const EdgeInsets.all(16),
      // padding around the grid
      itemCount: modules.length,
      itemBuilder: (context, index) {
        return ModuleItem(
          name: modules[index]['name'],
          color: Colors.white,
          padding: 20,
          icon: modules[index]['icon'],
          onTap: () => print('Tapped'),
        );
      },
    );
  }
}
