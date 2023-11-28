import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

import '../../theme/color.dart';
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
    return _buildBody();
  }

  _buildBody() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStringItem('File Name', fileName),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('File Number', fileNumber),
              _buildStringItem(
                  'Date opened',
                  DateFormat("dd/MM/yyyy").format(
                      DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateCreated))),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Client Name', clientName),
              FileItemStatus(
                  name:
                      status.contains('OUT OF COURT') ? 'Out Of Court' : status,
                  bgColor: Colors.green,
                  horizontalPadding: 20,
                  verticalPadding: 5),
            ],
          ),
        ],
      ),
    );
  }

  _buildStringItem(String title, String? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        SearchHighlightText(
          data ?? 'Null',
          style: const TextStyle(
            // fontWeight: FontWeight.bold,
            color: AppColors.darker,
          ),
          highlightStyle: const TextStyle(
            // fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: AppColors.darker,
            backgroundColor: AppColors.searchText,
          ),
        ),
      ],
    );
  }
}
