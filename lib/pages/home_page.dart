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
  var appbarPresent = true;
  var bottomBarPresent = true;
  var columnCount = 2;
  var minRowCountOnScreen = 2;
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
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    if(appbarPresent){
      height -= kToolbarHeight;
    }
    if(bottomBarPresent){
      height -= kBottomNavigationBarHeight;
    }
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2, // number of items in each row
      mainAxisSpacing: 20, // spacing between rows
      crossAxisSpacing: 20, // spacing between columns
      childAspectRatio: (width / columnCount) / (height / minRowCountOnScreen),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: 16,
      ),
      // padding around the grid
      children: modules
          .map(
            (item) => ModuleItem(
                name: item['name'],
                color: Colors.white,
                padding: 20,
                icon: item['icon'],
                onTap: () => print('Tapped')),
          )
          .toList(),
    );
  }
}
