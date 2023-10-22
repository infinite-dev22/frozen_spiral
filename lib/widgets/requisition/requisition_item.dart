import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/widgets/requisition/reuisition_item_status.dart';

import '../../theme/color.dart';

class RequisitionItem extends StatelessWidget {
  const RequisitionItem(
      {super.key,
      required this.fileName,
      required this.requisitionNumber,
      required this.dateCreated,
      required this.color,
      required this.padding,
      required this.status,
      required this.category,
      required this.description,
      required this.requesterName,
      required this.supervisorName,
      required this.amount,
      this.financialStatus,
      this.showFinancialStatus = false});

  final String fileName;
  final String requisitionNumber;
  final String category;
  final String description;
  final String requesterName;
  final String supervisorName;
  final String amount;
  final String? financialStatus;
  final String dateCreated;
  final bool showFinancialStatus;

  // final String clientName;
  final String status;
  final Color color;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Process'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Pay out'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Edit'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _buildStringItem('File Name', fileName),
          const SizedBox(
            height: 10,
          ),
          if (showFinancialStatus)
            Column(
              children: [
                _buildStringItem('Financial Status', financialStatus!),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Requisition Number', requisitionNumber),
              _buildStringItem('Category', category),
            ],
          ),
          Text(
            dateCreated,
            style: const TextStyle(color: AppColors.inActiveColor),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildStringItem('Description', description),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Requester', requesterName),
              _buildStringItem('Supervisor', supervisorName),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Amount', amount),
              RequisitionItemStatus(
                  name: status,
                  bgColor: Colors.green,
                  horizontalPadding: 20,
                  verticalPadding: 5),
            ],
          ),
        ],
      ),
    );
  }

  _buildStringItem(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        Text(
          data,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
