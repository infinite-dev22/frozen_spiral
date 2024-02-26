import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/widgets/text_item.dart';

class ItemsWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const ItemsWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    var numberFormat = NumberFormat("###,###,###,###,##0.00");
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
          color: AppColors.white,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * .3,
                      child: Text(
                        "Items",
                        style: TextStyle(
                            color: AppColors.inActiveColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              if (invoice.invoiceItems != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: invoice.invoiceItems!.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth * .7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextItem(
                                    title: "Item Type",
                                    data: invoice.invoiceItems![index].item!
                                        .getName(),
                                  ),
                                  TextItem(
                                    title: "Item Description",
                                    data: invoice.invoiceItems![index].item!
                                        .description!,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextItem(
                                    title: "Sub total",
                                    data:
                                        "${invoice.currency!.code}-${numberFormat.format(invoice.invoiceItems![index].amount)}",
                                  ),
                                  TextItem(
                                    title: "Amount",
                                    data:
                                        "${invoice.currency!.code}-${numberFormat.format(invoice.invoiceItems![index].totalAmount)}",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (index != invoice.invoiceItems!.length - 1)
                          Divider(
                            color: AppColors.inActiveColor.shade200,
                          ),
                      ],
                    ),
                  ),
                ),
              Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: _buildGrandTotalItem(constraints),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: _buildAmountsItem(
                    "Net Total", _subTotalAmount(), constraints),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: _buildAmountsItem(
                    "Paid Total",
                    "${invoice.currency!.code}-${NumberFormat("###,###,###,###,##0.00").format(invoice.totalPaid ?? 0.00)}",
                    constraints),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: _buildAmountsItem(
                    "Balance",
                    "${invoice.currency!.code}-${NumberFormat("###,###,###,###,##0.00").format(invoice.balance ?? 0.00)}",
                    constraints),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGrandTotalItem(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Text(
            "GROSS TOTAL",
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * .35,
          child: Text(
            _totalAmount(),
            textAlign: TextAlign.right,
            style:
                TextStyle(color: AppColors.darker, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountsItem(
      String title, String data, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Text(
            title,
            style: TextStyle(
                color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * .35,
          child: Text(
            data,
            textAlign: TextAlign.right,
            style:
                TextStyle(color: AppColors.darker, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _totalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double totalAmount = 0.00;
    if (invoice.invoiceItems!.isNotEmpty) {
      for (var invoiceFormItem in invoice.invoiceItems!) {
        totalAmount = totalAmount + invoiceFormItem.totalAmount!;
      }
    }
    return "${invoice.currency!.code}-${thousandFormatter.format(totalAmount)}";
  }

  String _subTotalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double subTotalAmount = 0.00;
    if (invoice.invoiceItems!.isNotEmpty) {
      for (var invoiceFormItem in invoice.invoiceItems!) {
        subTotalAmount = subTotalAmount + invoiceFormItem.amount!;
      }
    }
    return "${invoice.currency!.code}-${thousandFormatter.format(subTotalAmount)}";
  }
}
