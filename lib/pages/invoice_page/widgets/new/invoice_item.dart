import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/currency/smart_currency.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/forms/invoice_form.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_item_status.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/theme/color.dart';

class InvoiceItemWidget extends StatefulWidget {
  const InvoiceItemWidget({
    super.key,
    required this.invoice,
    required this.color,
    required this.padding,
    this.showActions = false,
    this.showFinancialStatus = false,
  });

  final SmartInvoice invoice;

  final bool showActions;
  final Color color;
  final double padding;
  final bool showFinancialStatus;

  @override
  State<InvoiceItemWidget> createState() => _InvoiceItemWidgetState();
}

class _InvoiceItemWidgetState extends State<InvoiceItemWidget> {
  bool isProcessing = false;
  bool isLoading = false;
  var status;

  NumberFormat formatter =
      NumberFormat('###,###,###,###,###,###,###,###,###.##');

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    status = removeHtmlTags(widget.invoice.invoiceStatus!);

    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: EdgeInsets.all(widget.padding),
        margin: EdgeInsets.only(bottom: widget.padding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor.withOpacity(.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
          color: widget.color,
        ),
        child: isProcessing
            ? Stack(
                fit: StackFit.passthrough,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStringItem(
                              'Client', widget.invoice.client!.name),
                          const SizedBox(height: 5),
                          _buildStringItem(
                              'File Name', widget.invoice.caseFile!.fileName),
                          const SizedBox(height: 5),
                          _buildStringItem('Amount', widget.invoice.amount),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStringItem(
                              'Date',
                              DateFormat('dd/MM/yyyy')
                                  .format(widget.invoice.date!)),
                          const SizedBox(height: 5),
                          _buildStringItem('File Number',
                              widget.invoice.caseFile!.fileNumber),
                          const SizedBox(height: 5),
                          if (widget.invoice.invoiceStatus2 != null)
                            InvoiceItemStatus(
                                name: _checkInvoiceStatus(),
                                bgColor: _getInvoiceStatusColor(),
                                horizontalPadding: 20,
                                verticalPadding: 5),
                        ],
                      ),
                    ],
                  ).blur(blur: 3),
                  if (isLoading)
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator(radius: 18),
                      ),
                    )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStringItem('Client', widget.invoice.client!.name),
                      const SizedBox(height: 5),
                      if (widget.invoice.caseFile != null)
                        _buildStringItem(
                            'File Name', widget.invoice.caseFile!.fileName,
                            width: constraints.maxWidth * .6),
                      const SizedBox(height: 5),
                      _buildStringItem('Amount',
                          "${widget.invoice.currency!.code} - ${widget.invoice.amount ?? "0.00"}"),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.invoice.date != null)
                        _buildStringItem(
                            'Date',
                            DateFormat('dd/MM/yyyy')
                                .format(widget.invoice.date!)),
                      const SizedBox(height: 5),
                      if (widget.invoice.caseFile != null)
                        _buildStringItem(
                            'File Number', widget.invoice.caseFile!.fileNumber),
                      const SizedBox(height: 5),
                      if (widget.invoice.invoiceStatus2 != null)
                        InvoiceItemStatus(
                            name: _checkInvoiceStatus(),
                            bgColor: _getInvoiceStatusColor(),
                            horizontalPadding: 20,
                            verticalPadding: 5),
                    ],
                  ),
                ],
              ),
      );
    });
  }

  String _checkInvoiceStatus() {
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("submitted".toLowerCase())) {
      return "Submitted";
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("edited".toLowerCase())) {
      return "Edited";
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("rejected".toLowerCase())) {
      return "Rejected";
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("returned".toLowerCase())) {
      return "Returned";
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("approved".toLowerCase())) {
      return "Approved";
    }
    return "No Action";
  }

  Color _getInvoiceStatusColor() {
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("submitted".toLowerCase())) {
      return AppColors.blue;
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("edited".toLowerCase())) {
      return AppColors.purple;
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("rejected".toLowerCase())) {
      return AppColors.red;
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("returned".toLowerCase())) {
      return AppColors.orange;
    }
    if (widget.invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("approved".toLowerCase())) {
      return AppColors.green;
    }
    return AppColors.transparent;
  }

  _buildStringItem(String title, String? data, {double? width}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.inActiveColor,
            ),
          ),
          SearchHighlightText(
            data ?? 'Null',
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              color: AppColors.darker,
            ),
            softWrap: true,
            highlightStyle: const TextStyle(
              // fontSize: 14,
              // fontWeight: FontWeight.bold,
              color: AppColors.darker,
              backgroundColor: AppColors.searchText,
            ),
          ),
        ],
      ),
    );
  }

  _buildFinancialStatusStringItem(String title, String? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.inActiveColor,
          ),
        ),
        Text(
          data ?? 'Null',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: (double.parse(widget.invoice.amount!.replaceAll(",", '')) >
                      0)
                  ? AppColors.green
                  : (double.parse(widget.invoice.amount!.replaceAll(",", '')) ==
                          0)
                      ? AppColors.blue
                      : AppColors.red),
        ),
      ],
    );
  }

  _buildInvoiceForm(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => InvoiceForm(),
    );
  }

  // _approveInvoice() {
  //   setState(() {
  //     isProcessing = true;
  //     isLoading = true;
  //   });
  //
  //   if (status == 'EDITED' || status == "SUBMITTED") {
  //     if (widget.invoice.canApprove ?? false) {
  //       _submitData("APPROVED", 'Invoice approved');
  //     } else if (widget.invoice.canApprove ?? false) {
  //       if (widget.invoice.secondApprover != null &&
  //           widget.invoice.secondApprover) {
  //         _submitData("SECONDARY_APPROVED", 'Invoice approved');
  //       } else {
  //         _submitData("PRIMARY_APPROVED", 'Invoice primarily approved');
  //       }
  //     }
  //   } else if (status == "PRIMARY_APPROVED") {
  //     _submitData("SECONDARY_APPROVED", 'Invoice approved');
  //   }
  // }

  // _submitData(String value, String toastText) {
  //   InvoiceApi.process({
  //     "forms": 1,
  //     "payout_amount": widget.invoice.amount!,
  //     "action_comment": "",
  //     "submit": value,
  //   }, widget.invoice.id!,
  //           onError: _onError, onSuccess: () => _onSuccess(toastText))
  //       .then((value) => _onSuccess(toastText))
  //       .onError((error, stackTrace) => _onError());
  // }

  _onSuccess(String text) async {
    InvoiceApi.fetchAll().then((value) {
      // AwesomeDialog(
      //   context: widget.parentContext!,
      //   dialogType: DialogType.success,
      //   animType: AnimType.bottomSlide,
      //   title: 'Success',
      //   desc: 'Invoice has been successfully approved',
      //   autoHide: const Duration(seconds: 2),
      //   btnCancel: null,
      //   btnOkOnPress: () {},
      // ).show();

      Fluttertoast.showToast(
          msg: "Invoice approved successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: AppColors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      isProcessing = false;
      preloadedInvoices.remove(widget.invoice);
      isLoading = false;
      if (mounted) setState(() {});
    });
  }

  _onError() async {
    Fluttertoast.showToast(
        msg: "An error occurred",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: AppColors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    isProcessing = false;
    isLoading = false;
    setState(() {});
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
    return document.text ?? "N/A";
  }
}
