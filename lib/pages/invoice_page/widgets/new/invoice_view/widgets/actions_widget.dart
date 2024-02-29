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
  final BuildContext context;

  const ActionsWidget(
      {super.key, required this.invoice, required this.context});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return (!invoice.invoiceStatus2!.code.toLowerCase().contains("preview") &&
            !invoice.invoiceStatus2!.code.toLowerCase().contains("approved") &&
            !invoice.invoiceStatus2!.code.toLowerCase().contains("rejected") &&
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
                  if (!invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("returned"))
                    const SizedBox(width: 5),
                  if (!invoice.invoiceStatus2!.code
                      .toLowerCase()
                      .contains("returned"))
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
        invoice.invoiceStatus2!.code == "SUBMITTED" ||
        invoice.invoiceStatus2!.code == "RETURNED") {
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
        invoice.invoiceStatus2!.code == "SUBMITTED" ||
        invoice.invoiceStatus2!.code == "RETURNED") {
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
  }
}
