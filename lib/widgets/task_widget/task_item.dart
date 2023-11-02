import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_task.dart';
import 'package:smart_case/widgets/task_widget/task_status_item.dart';
import 'package:smart_case/widgets/text_item.dart';

import '../../theme/color.dart';

class TaskItem extends StatelessWidget {
  final SmartTask task;

  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(
                  title: 'Date',
                  data: DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd')
                      .parse(
                          DateFormat('yyyy-MM-dd').format(task.dueAt!)))),
              TextItem(title: 'Done by', data: task.assignees!.last.getName()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextItem(
                  title: 'Client', data: task.caseFile!.clientName ?? 'N/A'),
              const TextItem(title: 'Cost', data: 'Coming soon...'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMediationStatusItem('Task'),
              const TextItem(title: 'Cost description', data: 'Coming soon...'),
            ],
          ),
          TextItem(title: 'Task description', data: task.description!),
        ],
      ),
    );
  }

  // _buildBody() {
  //   return Container(
  //     padding: EdgeInsets.all(padding),
  //     margin: EdgeInsets.only(bottom: padding),
  //     decoration: BoxDecoration(
  //       borderRadius: const BorderRadius.all(
  //         Radius.circular(8),
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.shadowColor.withOpacity(.1),
  //           spreadRadius: 1,
  //           blurRadius: 1,
  //           offset: const Offset(0, 1), // changes position of shadow
  //         ),
  //       ],
  //       color: color,
  //     ),
  //     child: Row(
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextItem(title: 'Date', data: dateCreated),
  //             TextItem(title: 'Client', data: clientName),
  //             _buildMediationStatusItem('Task'),
  //             TextItem(
  //                 title: 'Task description',
  //                 data: description /*and a bunch of other petty stuff*/),
  //           ],
  //         ),
  //         const Expanded(child: SizedBox()),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             TextItem(title: 'Done by', data: doneBy),
  //             TextItem(title: 'Cost', data: '$cost/='),
  //             TextItem(
  //                 title: 'Cost description',
  //                 data: costDescription),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _buildMediationStatusItem(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        const TaskItemStatus(
            name: 'Coming soon...',
            bgColor: AppColors.inActiveColor,
            horizontalPadding: 20,
            verticalPadding: 5),
      ],
    );
  }
}
