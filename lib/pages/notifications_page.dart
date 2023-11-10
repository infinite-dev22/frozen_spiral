import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/notification_item.dart';

import '../models/local/notifications.dart';

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
          isNetwork: currentUserImage != null ? true : false,
        ),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return (kDebugMode)
        ? ValueListenableBuilder(
            valueListenable:
                Hive.box<Notifications>('notifications').listenable(),
            builder: (context, Box<Notifications> box, _) {
              if (box.values.isEmpty) {
                return const Center(child: Text("Your alerts appear here"));
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
                      onDismissed: () {
                        _deleteItem(index);
                      },
                    );
                  },
                );
              }
            })
        : const Center(
            child: Text(
              'Coming soon...',
              style: TextStyle(
                color: AppColors.inActiveColor,
              ),
            ),
          );
  }

  _deleteItem(int index) async {
    await Hive.box<Notifications>('notifications').deleteAt(index).whenComplete(
        () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Dismissed'))));
    setState(() {});
  }
}
