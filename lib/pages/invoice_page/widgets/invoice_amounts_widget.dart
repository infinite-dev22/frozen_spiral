import 'package:flutter/material.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class InvoiceAmountsWidget extends StatelessWidget {
  final double subTotal;
  final double taxRate;
  final double tax;
  final double total;

  const InvoiceAmountsWidget({
    super.key,
    this.taxRate = 0,
    this.subTotal = 0,
    this.tax = 0,
    this.total = 0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          SpacedTextItem(
            title: 'Subtotal',
            data: subTotal.toString(),
          ),
          SpacedTextItem(
            title: 'Tax ($taxRate%)',
            data: tax.toString(),
          ),
          SpacedTextItem(
            title: 'Total',
            data: total.toString(),
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
