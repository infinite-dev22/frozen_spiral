import 'package:flutter/material.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/theme/color.dart';

class InvoiceItemWidget extends StatelessWidget {
  final Color color;
  final double padding;
  final SmartInvoice invoice;

  const InvoiceItemWidget({
    super.key,
    required this.color,
    required this.padding,
    required this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        padding,
        0,
        padding,
        padding,
      ),
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
        children: [
          _buildStringItem('Client', "Juliet Justin Ohio"),
          _buildStringItem('File', "Stabex Oil Vs Lands Ministry"),
          _buildStringItem('Total Amount', "100,424,000"),
          _buildStringItem('Approver', "Willian Oslo Rhydington"),
        ],
      ),
    );
  }

  Widget _buildStringItem(String title, String? data) {
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
