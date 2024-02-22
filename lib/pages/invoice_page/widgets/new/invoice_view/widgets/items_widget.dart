import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/theme/color.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth * .3,
                      child: Text(
                        "Description",
                        style: TextStyle(
                            color: AppColors.inActiveColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * .25,
                      child: Text(
                        "Amount(${invoice.currency!.code})",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: AppColors.inActiveColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * .3,
                      child: Text(
                        "SUBTOTAL(${invoice.currency!.code})",
                        textAlign: TextAlign.right,
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
                              width: constraints.maxWidth * .3,
                              child: SingleChildScrollView(
                                child: Text(
                                  invoice.invoiceItems![index].description!,
                                  style: TextStyle(
                                      color: AppColors.darker,
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                ),
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * .25,
                              child: Text(
                                numberFormat.format(
                                    invoice.invoiceItems![index].amount),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: AppColors.darker,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth * .3,
                              child: Text(
                                numberFormat.format(
                                    invoice.invoiceItems![index].totalAmount),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    color: AppColors.darker,
                                    fontWeight: FontWeight.bold),
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
                child: _buildItemsTableAmounts(constraints),
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
                child: _buildAmountsItem("Paid Total", invoice.totalPaid ?? "0.00", constraints),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                child: _buildAmountsItem("Balance", invoice.balance ?? "0.00", constraints),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildItemsTableAmounts(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Net Total",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Gross Total",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColors.inActiveColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * .35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_subTotalAmount()),
              const SizedBox(height: 10),
              Text(_totalAmount()),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrandTotalItem(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: Text(
            "GRAND TOTAL",
            style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: constraints.maxWidth * .35,
          child: Text(
            invoice.amount ?? "0.00",
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
    return thousandFormatter.format(totalAmount);
  }

  String _subTotalAmount() {
    var thousandFormatter = NumberFormat("###,###,###,###,##0.00");
    double subTotalAmount = 0.00;
    if (invoice.invoiceItems!.isNotEmpty) {
      for (var invoiceFormItem in invoice.invoiceItems!) {
        subTotalAmount = subTotalAmount + invoiceFormItem.amount!;
      }
    }
    return thousandFormatter.format(subTotalAmount);
  }
}
