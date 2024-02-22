import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smart_case/database/local/notifications.dart';
import 'package:smart_case/pages/home_page/widgets/module/module_item.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title:
            AppBarContent(isNetwork: currentUser.avatar != null ? true : false),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildGridColumns(),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   setState(() {});
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: AppColors.primary,
  //       title:
  //           AppBarContent(isNetwork: currentUser.avatar != null ? true : false),
  //     ),
  //     body: ListView(children: [_buildGridColumns()]),
  //   );
  // }

  // _buildBody() {
  //   return GridView.count(
  //     shrinkWrap: true,
  //     crossAxisCount: 2,
  //     // number of items in each row
  //     mainAxisSpacing: 20,
  //     // spacing between rows
  //     crossAxisSpacing: 20,
  //     // spacing between columns
  //     padding: const EdgeInsets.only(
  //       left: 16,
  //       right: 16,
  //       bottom: 16,
  //     ),
  //     // padding around the grid
  //     children: modules
  //         .map(
  //           (item) => ModuleItem(
  //               name: item['name'],
  //               color: Colors.white,
  //               padding: 20,
  //               icon: item['icon'],
  //               onTap: () => print('Tapped')),
  //         )
  //         .toList(),
  //   );
  // }

  Widget _buildGridColumns() {
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
                  icon: FontAwesome.hourglass,
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
                  icon: FontAwesome.list_solid,
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
                  icon: FontAwesome.calendar_days,
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
                  icon: FontAwesome.file,
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
                  name: 'Invoices',
                  color: Colors.white,
                  padding: cardPadding,
                  icon: FontAwesome.file_invoice_dollar_solid,
                  onTap: () => Navigator.pushNamed(context, '/invoices'),
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
                  icon: FontAwesome.chart_pie_solid,
                  onTap: () => Navigator.pushNamed(context, '/reports'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotification() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Notifications>('notifications').listenable(),
        builder: (context, Box<Notifications> box, _) {
          var unreadNotificationsLength =
              box.values.where((element) => element.read == false).length;
          return IconButton(
            onPressed: () {},
            icon: (unreadNotificationsLength > 0)
                ? Badge(
                    label: Text(unreadNotificationsLength.toString()),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.white,
                  ),
          );
        });
  }
}
