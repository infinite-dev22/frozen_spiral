import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/pages/invoice_page/widgets/invoice_form_item_list_item.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class InvoiceAmountsWidget extends StatelessWidget {
  final BuildContext parentContext;

  const InvoiceAmountsWidget({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            height: (invoiceFormItemList.length > 2) ? 300 : null,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: invoiceFormItemList.length,
              itemBuilder: (context, index) => InvoiceFormItemListItem(
                grandParentContext: parentContext,
                index: index,
                item: invoiceFormItemList[index],
              ),
            ),
          ),
          // Column(
          //   children: invoiceFormItemListItemList,
          // ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor.withOpacity(.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SpacedTextItem(
                  title: 'Subtotal',
                  data: _subTotalAmount(),
                ),
                const SizedBox(height: 8),
                SpacedTextItem(
                  title: 'Taxable Amount',
                  data: _totalTaxableAmount(),
                ),
                const SizedBox(height: 8),
                SpacedTextItem(
                  title: 'Total Amount',
                  data: _totalAmount(),
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _totalTaxableAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double totalTaxableAmount = 0.00;
    if (invoiceFormItemList.isNotEmpty) {
      for (var invoiceFormItem in invoiceFormItemList) {
        if (invoiceFormItem.taxableAmount != null) {
          totalTaxableAmount =
              totalTaxableAmount + invoiceFormItem.taxableAmount!;
        }
      }
    }
    ttlTaxableAmount = thousandFormatter.format(totalTaxableAmount);
    return ttlTaxableAmount!;
  }

  String _totalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double totalAmount = 0.00;
    if (invoiceFormItemList.isNotEmpty) {
      for (var invoiceFormItem in invoiceFormItemList) {
        totalAmount = totalAmount + invoiceFormItem.totalAmount!;
      }
    }
    ttlAmount = thousandFormatter.format(totalAmount);
    return ttlAmount!;
  }

  String _subTotalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double subTotalAmount = 0.00;
    if (invoiceFormItemList.isNotEmpty) {
      for (var invoiceFormItem in invoiceFormItemList) {
        subTotalAmount = subTotalAmount + invoiceFormItem.amount!;
      }
    }
    ttlSubAmount = thousandFormatter.format(subTotalAmount);
    return ttlSubAmount!;
  }
}
