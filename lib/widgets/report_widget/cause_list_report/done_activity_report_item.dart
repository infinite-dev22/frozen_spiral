import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/reports/models/done_activities_report.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class DoneActivityReportItem extends StatelessWidget {
  const DoneActivityReportItem({super.key, required this.doneActivity});

  final SmartDoneActivityReport doneActivity;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    var padding = 8.0;

    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.only(bottom: padding),
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
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FreeTextItem(
                      title: "Activity Date",
                      data: DateFormat('dd/MM/yyyy h:m a')
                          .format(doneActivity.date!),
                    ),
                    FreeTextItem(
                      title: "From",
                      data: DateFormat('dd/MM/yyyy h:m a')
                          .format(doneActivity.from),
                    ),
                    FreeTextItem(
                      title: "To",
                      data: DateFormat('dd/MM/yyyy h:m a')
                          .format(doneActivity.from),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      child: FreeTextItem(
                        title: "Activity",
                        data: doneActivity.caseActivityStatus.getName(),
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: FreeTextItem(
                        title: "Done by",
                        data: doneActivity.employee.getName(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth,
                      child: FreeTextItem(
                        title: "File Name",
                        data:
                            "${doneActivity.caseFile.getName()} | ${doneActivity.caseFile.fileNumber}",
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: FreeTextItem(
                        title: "Description",
                        data: (doneActivity.description != null)
                            ? doneActivity.description!
                            : "N/A",
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
