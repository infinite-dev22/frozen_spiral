import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/screen_arguments.dart';
import 'package:smart_case/database/activity/activity_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/activity_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/text_item.dart';

class ActivityViewPage extends StatefulWidget {
  const ActivityViewPage({super.key});

  @override
  State<ActivityViewPage> createState() => _ActivityViewPageState();
}

class _ActivityViewPageState extends State<ActivityViewPage> {
  SmartActivity? activity;
  late int fileId;
  late int activityId;

  @override
  Widget build(BuildContext context) {
    try {
      activity = ModalRoute.of(context)!.settings.arguments as SmartActivity;
    } catch (e) {
      ScreenArguments screenArguments =
          ModalRoute.of(context)!.settings.arguments as ScreenArguments;
      fileId = int.parse(screenArguments.fieldOne);
      activityId = int.parse(screenArguments.fieldTwo);

      _setupData(fileId, activityId);
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
    return (activity != null)
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextItem(title: "Activity Name:", data: activity!.getName()),
                const Divider(),
                TextItemMacquee(
                    title: "Case File Name:", data: activity!.file!.fileName!),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextItem(
                            title: "Activity Date:",
                            data: DateFormat('dd/MM/yyyy')
                                .format(activity!.date!)),
                        TextItem(
                            title: "From:",
                            data: DateFormat.jm().format(activity!.startTime!)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextItem(
                            title: "Done By:",
                            data: "${activity!.employee!.firstName}"
                                " ${activity!.employee!.lastName}"),
                        TextItem(
                            title: "To:",
                            data: DateFormat.jm().format(activity!.endTime!)),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                FreeTextItem(
                    title: "Description:", data: activity!.description!),
              ],
            ),
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.gray45,
              radius: 20,
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

  _setupData(int fileId, int activityId) async {
    await ActivityApi.fetch(fileId, activityId).then((value) {
      activity = value;
      if (mounted) setState(() {});
    });
  }
}
