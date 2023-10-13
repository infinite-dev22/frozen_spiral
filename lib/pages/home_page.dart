import 'package:flutter/material.dart';
import 'package:smart_case/data/data.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/module_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 20, // spacing between rows
          crossAxisSpacing: 20, // spacing between columns
          // childAspectRatio: 2      ),
        ),
        padding: const EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom: 16,
        ),
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
      ),
    );
  }
}
