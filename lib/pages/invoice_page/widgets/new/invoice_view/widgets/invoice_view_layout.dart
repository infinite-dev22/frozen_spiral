import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/bloc/invoice_bloc.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_view/widgets/invoice_view_barrel.dart';
import 'package:smart_case/theme/color.dart';

class InvoiceViewLayout extends StatelessWidget {
  final int? invoiceId;
  final SmartInvoice? invoice;
  final BuildContext? parentContext;

  const InvoiceViewLayout({
    super.key,
    this.invoiceId,
    this.invoice,
    this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        if (state.status == InvoiceStatus.viewError) {
          Navigator.pop(context);
          _onError("An error occurred whilst fetching an Invoice");
        }
        if (state.status == InvoiceStatus.invoiceApproveSuccess) {
          Navigator.pop(context);
          _onSuccess("Invoice action successful");
          context.read<InvoiceBloc>().add(GetInvoices());
        }
        if (state.status == InvoiceStatus.invoiceApproveError) {
          _onError("Invoice action failed, try again");
        }
      },
      child: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (invoice != null && state.status == InvoiceStatus.initial) {
            context.read<InvoiceBloc>().add(SetInvoice(invoice!));
          }
          if (invoice == null &&
              invoiceId != null &&
              state.status == InvoiceStatus.initial) {
            context.read<InvoiceBloc>().add(ViewGetInvoice(invoiceId!));
          }
          if (state.status == InvoiceStatus.viewLoading) {
            return ViewLoadingWidget();
          }
          if (state.status == InvoiceStatus.viewSuccess) {
            return ViewSuccessLayout();
          }
          return Container(
            child: Center(
              child: Text("Default Widget Showing"),
            ),
          );
        },
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
    // preloadedInvoices.remove(invoice);
    preloadedInvoices.removeWhere((element) => element.id == invoiceId);
  }

  _onError(String text) async {
    refreshInvoices = true;

    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
        fontSize: 16.0);
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
}
