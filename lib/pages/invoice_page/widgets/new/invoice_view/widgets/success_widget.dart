import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/bloc/forms/invoice/invoice_form_bloc.dart';
import 'package:smart_case/pages/invoice_page/bloc/invoice_bloc.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_form.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/actions_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/bank_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/info_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/items_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/terms_widget.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/to_widget.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/form_title.dart';

class ViewSuccessLayout extends StatelessWidget {
  const ViewSuccessLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    SmartInvoice invoice = context.read<InvoiceBloc>().state.invoice!;

    return Scaffold(
      floatingActionButton: SizedBox(
          height: 110,
          child: ActionsWidget(invoice: invoice, context: context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: AppColors.transparent,
      body: Column(
        children: [
          InvoiceViewTitle(
            onEdit: () => _buildInvoiceDialog(context, invoice),
            onPrint: () {},
            onSave: () => _submitFormData(context, invoice),
            isElevated: true,
            invoice: invoice,
          ),
          Expanded(
            child: ListView(
              children: [
                InfoWidget(invoice: invoice),
                if ((invoice.client != null && invoice.client!.address != null))
                  ToWidget(invoice: invoice),
                BankWidget(invoice: invoice),
                ItemsWidget(invoice: invoice),
                TermsWidget(invoice: invoice),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
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

  _submitData(String value, String toastText, int invoiceId) {
    SmartCaseApi.smartPost(
      'api/accounts/invoices/${invoiceId}/process',
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

  fetchInvoice(int invoiceId) async {
    return await InvoiceApi.fetch(invoiceId, onError: () {
      _onError();
    });
  }

  String removeHtmlTags(String htmlString) {
    // Parse the HTML string into a Document object.
    var document = parse(htmlString);

    // Find all the elements in the document.
    var elements = document.getElementsByTagName('*');

    // Iterate through the elements and remove their tags.
    for (var element in elements) {
      element.remove();
    }

    // Return the text content of the document.
    return document.text!;
  }

  _submitFormData(BuildContext context, SmartInvoice invoice) {
    InvoiceApi.post(
      invoice,
      onError: () {
        Fluttertoast.showToast(
            msg: "An error occurred",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
            fontSize: 16.0);
      },
      onSuccess: () {
        Fluttertoast.showToast(
            msg: "Invoice added successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: AppColors.green,
            textColor: AppColors.white,
            fontSize: 16.0);
      },
    );

    Navigator.pop(context);
    Navigator.pop(context);
  }

  _buildInvoiceDialog(BuildContext context, SmartInvoice invoice) {
    context.read<InvoiceFormBloc>().add(EditInvoiceForm(invoice));
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => InvoiceForm(),
    );
  }
}
