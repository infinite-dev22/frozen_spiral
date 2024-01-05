import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/task/task_model.dart';
import 'package:smart_case/pages/task_page/widgets/task_form.dart';
import 'package:smart_case/pages/task_page/widgets/task_status_item.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_icon_button.dart';
import 'package:smart_case/widgets/text_item.dart';

class TaskItem extends StatelessWidget {
  final SmartTask task;

  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                      data: DateFormat('dd/MM/yyyy').format(
                          DateFormat('yyyy-MM-dd').parse(
                              DateFormat('yyyy-MM-dd').format(task.dueAt!)))),
                ],
              ),
              TextItem(title: 'Task', data: task.getName()),
              TextItem(title: 'Task description', data: task.description!),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextItem(title: 'Assigner', data: task.assigner!.getName()),
                  Column(
                    children: [
                      const Text(
                        "Assignees",
                        style: TextStyle(
                          color: AppColors.inActiveColor,
                        ),
                      ),
                      for (var assignee in task.assignees!)
                        Text(
                          assignee.getName(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        if (task.createdBy == currentUser.id)
          Positioned(
            right: 0,
            top: 0,
            child: MaterialButton(
              padding: const EdgeInsets.all(5),
              onPressed: () => _onPressed(context),
              child: const CustomIconButton(),
            ),
          ),
      ],
    );
  }

  _onPressed(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      backgroundColor: AppColors.appBgColor,
      builder: (context) => TaskForm(
        task: task,
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
