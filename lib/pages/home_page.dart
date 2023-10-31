import 'package:flutter/material.dart';
import 'package:smart_case/data/data.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/module_item.dart';

import '../util/smart_case_init.dart';

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
        title:
            AppBarContent(isNetwork: currentUser.avatar != null ? true : false),
      ),
      body: ListView(children: [_buildGridColumns()]),
    );
  }

  _buildBody() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      // number of items in each row
      mainAxisSpacing: 20,
      // spacing between rows
      crossAxisSpacing: 20,
      // spacing between columns
      padding: const EdgeInsets.only(
        left: 16,
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

  _buildGridColumns() {
    double cardPadding = MediaQuery.of(context).size.height * .038;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ModuleItem(
                  name: 'Activities',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: Icons.local_activity_outlined,
                  onTap: () => Navigator.pushNamed(context, '/activities'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ModuleItem(
                  name: 'Requisitions',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: Icons.list_rounded,
                  onTap: () => Navigator.pushNamed(context, '/requisitions'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ModuleItem(
                  name: 'Diary',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: Icons.calendar_month_rounded,
                  onTap: () => Navigator.pushNamed(context, '/events'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ModuleItem(
                  name: 'Tasks',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: Icons.task_outlined,
                  onTap: () => Navigator.pushNamed(context, '/tasks'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ModuleItem(
                  name: 'Engagements',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: Icons.handshake_outlined,
                  onTap: () => Navigator.pushNamed(context, '/engagements'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ModuleItem(
                  name: 'Reports',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: Icons.bar_chart_rounded,
                  onTap: () => Navigator.pushNamed(context, '/reports'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
