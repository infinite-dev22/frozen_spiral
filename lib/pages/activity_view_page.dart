import 'package:flutter/material.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/widgets/text_item.dart';

import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class ActivityViewPage extends StatefulWidget {
  const ActivityViewPage({super.key});

  @override
  State<ActivityViewPage> createState() => _ActivityViewPageState();
}

class _ActivityViewPageState extends State<ActivityViewPage> {
  SmartActivity? activity;
  late int activityId;

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      activity = ModalRoute.of(context)!.settings.arguments as SmartActivity;
    } else {
      String activityIdAsString =
          ModalRoute.of(context)!.settings.arguments as String;
      activityId = int.parse(activityIdAsString);
    }

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUser.avatar != null ? true : false,
          canNavigate: true,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextItem(title: "Activity Name:", data: activity!.getName()),
          const Divider(indent: 10, endIndent: 10),
          TextItem(title: "Case File Name:", data: activity!.file!.fileName!),
          const Divider(indent: 10, endIndent: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(
                  title: "Activity Date:", data: activity!.date!.toString()),
              const TextItem(title: "Done By:", data: "Coming soon..."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(title: "From:", data: activity!.startTime.toString()),
              TextItem(title: "To:", data: activity!.endTime.toString()),
            ],
          ),
          const Divider(indent: 10, endIndent: 10),
          TextItem(title: "Description:", data: activity!.description!),
        ],
      ),
    );
  }

// _setupData() async {
//   await SmartCaseApi.smartDioFetch(
//       "api/accounts/requisitions/$requisitionId/process", currentUser.token,
//       onError: () {
//     _onError();
//   }).then((value) {
//     requisition = SmartRequisition.fromJsonToView(value['requisition']);
//     amountController.text =
//         formatter.format(double.parse(requisition!.amount!));
//     setState(() {});
//   });
// }
}
