import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/notification_item.dart';

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
    final Random random = Random();
    return (true)
        ? ListView.builder(
            itemCount: 10,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              String time = DateFormat('h:mm a').format(
                  DateTime.now().add(Duration(minutes: random.nextInt(200))));
              return NotificationItem(
                  title: "Test notification $index",
                  time: time,
                  body:
                      "Cumque earum ut magnam aut. Molestiae eum nisi eum est dolorum ut architecto. Est doloremque harum aut voluptas dolores saepe. Molestiae velit assumenda sit cupiditate et fugiat quos. Quibusdam recusandae ipsum aspernatur nisi maxime dolorum. Officiis nihil illum accusantium iusto illo pariatur. Ratione hic blanditiis sunt incidunt est. In et distinctio laborum nobis et. Alias eius consectetur repudiandae deserunt deserunt impedit consequuntur eum.");
            },
          )
        : const Center(
            child: Text('Your alerts appear here'),
          );
  }
}
