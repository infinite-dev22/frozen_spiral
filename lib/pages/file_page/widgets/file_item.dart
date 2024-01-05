import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

import 'file_item_status.dart';

class FileItem extends StatelessWidget {
  const FileItem(
      {super.key,
      required this.fileName,
      required this.fileNumber,
      required this.dateCreated,
      required this.clientName,
      required this.color,
      required this.padding,
      required this.status});

  final String fileName;
  final String fileNumber;
  final String dateCreated;
  final String clientName;
  final String status;
  final Color color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
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
        color: color,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FreeTextItem(title: 'File Name', data: fileName),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextItem(title: 'File Number', data: fileNumber),
                TextItem(
                    title: 'Date opened',
                    data: DateFormat("dd/MM/yyyy").format(
                        DateFormat("yyyy-MM-dd'T'HH:mm:ss")
                            .parse(dateCreated))),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: constraints.maxWidth * .655,
                  child: FreeTextItem(
                    title: 'Client Name',
                    data: clientName,
                  ),
                ),
                FileItemStatus(
                    name: status.contains('OUT OF COURT')
                        ? 'Out Of Court'
                        : status,
                    bgColor: (status == 'No Activity')
                        ? AppColors.orange
                        : AppColors.green,
                    horizontalPadding: 20,
                    verticalPadding: 5),
              ],
            ),
          ],
        );
      }),
    );
  }
}
