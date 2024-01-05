import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/reports/models/cause_list_report.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class CauseListReportItem extends StatelessWidget {
  const CauseListReportItem({super.key, required this.causeReport});

  final SmartCauseListReport causeReport;

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
                      title: "Event Date",
                      data: (causeReport.date != null)
                          ? DateFormat('dd/MM/yyyy h:mm a')
                              .format(causeReport.date!)
                          : "N/A",
                    ),
                    FreeTextItem(
                      title: "Partner",
                      data: (causeReport.partners != null)
                          ? causeReport.partners!.first.getName()
                          : "N/A",
                    ),
                    FreeTextItem(
                      title: "Court",
                      data: (causeReport.court != null)
                          ? causeReport.court!.name
                          : "N/A",
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
                        data: (causeReport.title != null)
                            ? causeReport.title!
                            : "N/A",
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: FreeTextItem(
                        title: "To be done by",
                        data: (causeReport.toBeDoneBy != null)
                            ? causeReport.toBeDoneBy!
                            : "N/A",
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      child: FreeTextItem(
                        title: "Practice Area",
                        data: (causeReport.practiceArea != null)
                            ? causeReport.practiceArea!
                            : "N/A",
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
                            "${causeReport.fileName} | ${causeReport.fileNumber}",
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: FreeTextItem(
                        title: "Description",
                        data: (causeReport.description != null)
                            ? causeReport.description!
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
