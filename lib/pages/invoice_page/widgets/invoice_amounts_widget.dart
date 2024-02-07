import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class InvoiceAmountsWidget extends StatelessWidget {
  const InvoiceAmountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Column(
            children: invoiceFormItemListItemList,
          ),
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
    );
  }

  String _totalTaxableAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double totalTaxableAmount = 0.00;
    if (invoiceFormItemList.isNotEmpty) {
      invoiceFormItemList.forEach((invoiceFormItem) {
        totalTaxableAmount =
            totalTaxableAmount + invoiceFormItem.taxableAmount!;
      });
    }
    return thousandFormatter.format(totalTaxableAmount);
  }

  String _totalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double totalAmount = 0.00;
    if (invoiceFormItemList.isNotEmpty) {
      invoiceFormItemList.forEach((invoiceFormItem) {
        totalAmount = totalAmount + invoiceFormItem.totalAmount!;
      });
    }
    return thousandFormatter.format(totalAmount);
  }

  String _subTotalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double subTotalAmount = 0.00;
    if (invoiceFormItemList.isNotEmpty) {
      invoiceFormItemList.forEach((invoiceFormItem) {
        subTotalAmount = subTotalAmount + invoiceFormItem.amount!;
      });
    }
    return thousandFormatter.format(subTotalAmount);
  }
}
