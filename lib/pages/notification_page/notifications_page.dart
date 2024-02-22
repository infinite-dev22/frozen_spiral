import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_case/database/local/notifications.dart';
import 'package:smart_case/pages/notification_page/widgets/notification_item.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AlertsPageState();
}

class _AlertsPageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUser.avatar != null ? true : false,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<Notifications>('notifications').listenable(),
        builder: (context, Box<Notifications> box, _) {
          if (box.values.isEmpty) {
            return const Center(
                child: Text(
              "Your alerts appear here",
              style: TextStyle(color: AppColors.inActiveColor),
            ));
          } else {
            return ListView.builder(
              itemCount: box.values.length,
              padding: const EdgeInsets.only(right: 10),
              itemBuilder: (context, index) {
                var result = box.getAt(index);
                return NotificationItem(
                  title: result!.title!,
                  time: result.time ?? "",
                  body: result.body!,
                  read: result.read ?? true,
                  box: box,
                  index: index,
                  onDismissed: () {
                    _deleteItem(index);
                  },
                );
              },
            );
          }
        });
  }

  _deleteItem(int index) async {
    await Hive.box<Notifications>('notifications').deleteAt(index).whenComplete(
        () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Dismissed'))));
    setState(() {});
  }
}
