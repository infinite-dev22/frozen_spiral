import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_form_item.dart';
import 'package:smart_case/pages/invoice_page/bloc/forms/invoice/invoice_form_bloc.dart';
import 'package:smart_case/theme/color.dart';

class InvoiceFormItemListItem extends StatelessWidget {
  final InvoiceFormItem item;
  final int? index;
  final BuildContext grandParentContext;

  const InvoiceFormItemListItem(
      {super.key,
      this.index,
      required this.item,
      required this.grandParentContext});

  @override
  Widget build(BuildContext context) {
    var thousandFormatter = NumberFormat("###,###,###,###,###.##");
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        child: Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 100, child: Text(item.item!.getName())),
                  SizedBox(
                      width: 100,
                      child: Text(thousandFormatter
                          .parse(item.amount!.toString())
                          .toStringAsFixed(2))),
                  SizedBox(
                      width: 100,
                      child: Text(thousandFormatter
                          .parse(item.totalAmount!.toString())
                          .toStringAsFixed(2))),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_forever_rounded,
                      color: AppColors.red,
                    ),
                    onPressed: () {
                      invoiceFormItemList.removeAt(index!);
                      grandParentContext
                          .read<InvoiceFormBloc>()
                          .add(RefreshInvoiceForm(invoiceFormItemListItemList));
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              indent: 0,
              endIndent: 0,
              height: 15,
            ),
          ],
        ),
      );
    });
  }
}
