import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';

class InvoiceFormItemListItem extends StatelessWidget {
  final InvoiceFormItem item;

  const InvoiceFormItemListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var thousandFormatter = NumberFormat("###,###,###,###,###.##");
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        child: Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(child: Text(item.item!.getName())),
                  SizedBox(child: Text(thousandFormatter.parse(item.amount!.toString()).toStringAsFixed(2))),
                  SizedBox(child: Text(thousandFormatter.parse(item.totalAmount!.toString()).toStringAsFixed(2))),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
