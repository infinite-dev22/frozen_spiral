import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/bloc/invoice_bloc.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/theme/color.dart';

class ActionsWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const ActionsWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return (!invoice.invoiceStatus2!.code.toLowerCase().contains("preview") ||
            !invoice.invoiceStatus2!.code.toLowerCase().contains("approve") ||
            !invoice.invoiceStatus2!.code.toLowerCase().contains("rejected") ||
            invoice.invoiceStatus2 != null)
        ? Container(
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
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => _approveInvoice(context),
                    child: Text("Approve"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.green),
                    ),
                  ),
                  const SizedBox(width: 5),
                  FilledButton(
                    onPressed: () => _returnInvoice(context),
                    child: Text("Return"),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(AppColors.orange),
                    ),
                  ),
                  const SizedBox(width: 5),
                  FilledButton(
                    onPressed: () => _rejectInvoice(context),
                    child: Text("Reject"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(AppColors.red),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  _approveInvoice(BuildContext context) {
    if (invoice.invoiceStatus2!.code == 'EDITED' ||
        invoice.invoiceStatus2!.code == "SUBMITTED") {
      _submitData("approve", 'Invoice approved', context);
    } else if (invoice.invoiceStatus2!.code == "PRIMARY_APPROVED") {
      _submitData("secondary_approve", 'Invoice approved', context);
    }
  }

  _returnInvoice(BuildContext context) {
    if (invoice.invoiceStatus2!.code == 'EDITED' ||
        invoice.invoiceStatus2!.code == "SUBMITTED") {
      _submitData("return", 'Action successful', context);
    } else if (invoice.invoiceStatus2!.code == "PRIMARY_RETURNED") {
      _submitData("secondary_return", 'Action successful', context);
    }
  }

  _rejectInvoice(BuildContext context) {
    if (invoice.invoiceStatus2!.code == 'EDITED' ||
        invoice.invoiceStatus2!.code == "SUBMITTED") {
      _submitData("reject", 'Action successful', context);
    } else if (invoice.invoiceStatus2!.code == "PRIMARY_REJECTED") {
      _submitData("secondary_reject", 'Action successful', context);
    }
  }

  _submitData(String value, String toastText, BuildContext context) {
    context.read<InvoiceBloc>().add(ProcessInvoice(invoice.id!, {
          "comment": '',
          "submit": value,
        }));
    print("Invoice Id: ${invoice.id}");
    InvoiceApi.process(
      {
        "comment": '',
        "submit": value,
      },
      invoice.id!,
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
