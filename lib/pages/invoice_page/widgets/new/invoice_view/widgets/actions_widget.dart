import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/util/utilities.dart';

class ActionsWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const ActionsWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
        color: AppColors.white,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "${invoice.currency!.code}-${invoice.amount ?? "0.00"}",
                  style: TextStyle(
                    color: AppColors.darker,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                if (invoice.date != null)
                  Text(
                    "Due on ${formatDateTimeToString(invoice.date)}",
                    style: TextStyle(
                      color: AppColors.inActiveColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 10),
              ],
            ),
            FilledButton(
              onPressed: () {},
              child: Text(_checkInvoiceStatus() /*"APPROVE NOW"*/),
            ),
          ],
        ),
      ),
    );
  }

  String _checkInvoiceStatus() {
    if (invoice.invoiceStatus2!.name
        .toLowerCase()
        .contains("submitted for approval".toLowerCase())) {
      return "Approve Now";
    }
    return "No Action";
  }

  // Widget _buildButtons() {
  //   return (invoice!.canPay == true)
  //       ? Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             FilledButton(
  //               onPressed: (drawer != null &&
  //                       (drawer!.openingBalance! > 0 &&
  //                           drawer!.openingBalance! >=
  //                               double.parse(
  //                                   amountController.text.replaceAll(",", ""))))
  //                   ? _payoutInvoice
  //                   : (preloadedDrawers.isEmpty)
  //                       ? _payoutInvoice
  //                       : null,
  //               style: ButtonStyle(
  //                 backgroundColor: MaterialStateProperty.resolveWith(
  //                   (states) {
  //                     if (drawer != null &&
  //                         (drawer!.openingBalance! > 0 &&
  //                             drawer!.openingBalance! >=
  //                                 double.parse(amountController.text
  //                                     .replaceAll(",", "")))) {
  //                       return AppColors.green;
  //                     } else if (preloadedDrawers.isEmpty) {
  //                       return AppColors.green;
  //                     } else {
  //                       return Colors.green.shade200;
  //                     }
  //                   },
  //                 ),
  //               ),
  //               child: Text(
  //                 (drawer != null &&
  //                         (drawer!.openingBalance! > 0 &&
  //                             drawer!.openingBalance! >=
  //                                 double.parse(amountController.text
  //                                     .replaceAll(",", ""))))
  //                     ? 'Pay out'
  //                     : 'Select drawer with sufficient funds to continue',
  //               ),
  //             ),
  //           ],
  //         )
  //       : (invoice!.canApprove != null)
  //           ? Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 FilledButton(
  //                   onPressed: _approveInvoice,
  //                   style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.resolveWith(
  //                         (states) => AppColors.green),
  //                   ),
  //                   child: const Text(
  //                     'Approve',
  //                   ),
  //                 ),
  //                 FilledButton(
  //                   onPressed: _returnInvoice,
  //                   style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.resolveWith(
  //                         (states) => AppColors.orange),
  //                   ),
  //                   child: const Text(
  //                     'Return',
  //                   ),
  //                 ),
  //                 FilledButton(
  //                   onPressed: _rejectInvoice,
  //                   style: ButtonStyle(
  //                     backgroundColor: MaterialStateProperty.resolveWith(
  //                         (states) => AppColors.red),
  //                   ),
  //                   child: const Text(
  //                     'Reject',
  //                   ),
  //                 ),
  //               ],
  //             )
  //           : Container();
  // }

  _payoutInvoice() {
    _submitData("PAID", 'Pay out successful');
  }

  _approveInvoice() {
    if (invoice.invoiceStatus2!.code == 'EDITED' ||
        invoice.invoiceStatus2!.code == "SUBMITTED") {
      if (invoice.canApprove ?? false) {
        _submitData("APPROVED", 'Invoice approved');
      } else if (invoice.canApprove ?? false) {
        if (invoice.secondApprover != null && invoice.secondApprover) {
          _submitData("SECONDARY_APPROVED", 'Invoice approved');
        } else {
          _submitData("PRIMARY_APPROVED", 'Invoice primarily approved');
        }
      }
    } else if (invoice.invoiceStatus2!.code == "PRIMARY_APPROVED") {
      _submitData("SECONDARY_APPROVED", 'Invoice approved');
    }
  }

  _returnInvoice() {
    if (invoice.invoiceStatus2!.code == 'EDITED' ||
        invoice.invoiceStatus2!.code == "SUBMITTED") {
      if (invoice.canApprove ?? false) {
        _submitData("RETURNED", 'Action successful');
      } else if (invoice.canApprove ?? false) {
        _submitData("PRIMARY_RETURNED", 'Action successful');
      }
    } else if (invoice.invoiceStatus2!.code == "PRIMARY_RETURNED") {
      _submitData("SECONDARY_RETURNED", 'Action successful');
    }
  }

  _rejectInvoice() {
    if (invoice.invoiceStatus2!.code == 'EDITED' ||
        invoice.invoiceStatus2!.code == "SUBMITTED") {
      if (invoice.canApprove ?? false) {
        _submitData("REJECTED", 'Action successful');
      } else if (invoice.canApprove ?? false) {
        _submitData("PRIMARY_REJECTED", 'Action successful');
      }
    } else if (invoice.invoiceStatus2!.code == "PRIMARY_REJECTED") {
      _submitData("SECONDARY_REJECTED", 'Action successful');
    }
  }

  _submitData(String value, String toastText) {
    SmartCaseApi.smartPost(
      'api/accounts/invoices/${invoice.id}/process',
      currentUser.token,
      {
        // "payout_amount": amountController.text.trim(),
        // "action_comment": commentController.text.trim(),
        "submit": value,
      },
      onSuccess: () => _onSuccess(toastText),
      onError: _onError,
    );
  }

  _onSuccess(String text) async {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    // preloadedInvoices.remove(invoice);
    preloadedInvoices.removeWhere((element) => element.id == invoice.id);
  }

  _onError() async {
    refreshInvoices = true;

    Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
