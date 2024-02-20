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
import 'package:smart_case/util/smart_case_init.dart';

class InvoiceItem extends StatefulWidget {
  const InvoiceItem({
    super.key,
    required this.invoice,
    required this.color,
    required this.padding,
    this.showActions = false,
    this.showFinancialStatus = false,
    this.currencies,
  });

  final SmartInvoice invoice;
  final List<SmartCurrency>? currencies;

  final bool showActions;
  final Color color;
  final double padding;
  final bool showFinancialStatus;

  @override
  State<InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<InvoiceItem> {
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

    return Container(
      padding: EdgeInsets.fromLTRB(
        widget.padding,
        (widget.showActions) ? 0 : widget.padding,
        widget.padding,
        widget.padding,
      ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.showActions)
                      Column(
                        children: [
                          (widget.invoice.canApprove == null &&
                                  (widget.invoice.canPay == false ||
                                      widget.invoice.canPay == null) &&
                                  (!widget.invoice.isMine! &&
                                          !widget.invoice.canEdit! &&
                                          status != 'SUBMITTED' ||
                                      status != 'EDITED'))
                              ? Container()
                              : SizedBox(
                                  height: 33,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (widget.invoice.canApprove != null)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: FilledButton(
                                                onPressed: (isProcessing)
                                                    ? null
                                                    : _approveInvoice,
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                              (states) =>
                                                                  AppColors
                                                                      .green),
                                                ),
                                                child: const Text(
                                                  'Approve',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (widget.invoice.canPay == true)
                                        TextButton(
                                          onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/invoice',
                                            arguments: widget.invoice.id,
                                          ).then((_) => setState(() {})),
                                          child: const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.money_rounded),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Pay out')
                                            ],
                                          ),
                                        ),
                                      if (status == 'SUBMITTED' ||
                                          status == 'EDITED')
                                        TextButton(
                                          onPressed: () =>
                                              _buildInvoiceForm(context),
                                          child: const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(CupertinoIcons
                                                  .pencil_ellipsis_rectangle),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Edit')
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem(
                            'Date',
                            DateFormat('dd/MM/yyyy')
                                .format(widget.invoice.date!)),
                        _buildStringItem('Amount', '100,000'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem(
                            'File Name', widget.invoice.caseFile!.fileName),
                        _buildStringItem('Paid', '35,000'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem(
                            'File Number', widget.invoice.caseFile!.fileNumber),
                        _buildStringItem('Balance', '65,000'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.showFinancialStatus)
                      if (widget.invoice.amount != null)
                        Column(
                          children: [
                            _buildFinancialStatusStringItem(
                                'Financial Status (UGX)',
                                formatter.format(double.parse(widget
                                    .invoice.amount!
                                    .replaceAll(",", '')))),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem('Requestioner',
                            "${widget.invoice.employee!.firstName} ${widget.invoice.employee!.lastName}"),
                        _buildStringItem('Approver',
                            "${widget.invoice.approver!.firstName} ${widget.invoice.approver!.lastName}"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem(
                            'Amount (UGX)',
                            formatter.format(double.parse(
                                widget.invoice.amount!.replaceAll(",", "")))),
                        InvoiceItemStatus(
                            name: status == 'SECONDARY_APPROVED'
                                ? 'Approved'
                                : status == 'SECONDARY_REJECTED'
                                    ? 'Rejected'
                                    : status == 'SECONDARY_RETURNED'
                                        ? 'Returned'
                                        : status,
                            bgColor: status.toLowerCase().contains('approved')
                                ? AppColors.green
                                : status.toLowerCase().contains('rejected')
                                    ? AppColors.red
                                    : status.toLowerCase().contains('returned')
                                        ? AppColors.orange
                                        : status.toLowerCase().contains('paid')
                                            ? AppColors.purple
                                            : AppColors.blue,
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showActions)
                  Column(
                    children: [
                      (widget.invoice.canApprove == null &&
                              (((widget.invoice.canEdit ?? false) &&
                                      widget.invoice.employee!.id !=
                                          currentUser.id) &&
                                  (!status.toLowerCase().contains('submit') ||
                                      (!status.toLowerCase().contains('edit') &&
                                          widget.invoice.employee!.id !=
                                              currentUser.id) ||
                                      !status
                                          .toLowerCase()
                                          .contains("returned") ||
                                      (status
                                              .toLowerCase()
                                              .contains("returned") &&
                                          widget.invoice.employee!.id !=
                                              currentUser.id))))
                          ? Container()
                          : SizedBox(
                              height: 33,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (widget.invoice.canApprove != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: FilledButton(
                                            onPressed: (isProcessing)
                                                ? null
                                                : _approveInvoice,
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) =>
                                                          AppColors.green),
                                            ),
                                            child: const Text(
                                              'Approve',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (widget.invoice.canPay == true)
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/invoice',
                                        arguments: widget.invoice.id,
                                      ).then((_) => setState(() {})),
                                      child: const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.money_rounded),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Pay out')
                                        ],
                                      ),
                                    ),
                                  if ((widget.invoice.invoiceStatus != null) &&
                                      (status
                                              .toLowerCase()
                                              .contains('submit') ||
                                          status
                                              .toLowerCase()
                                              .contains('edit') ||
                                          status
                                              .toLowerCase()
                                              .contains("returned")) &&
                                      widget.invoice.employee!.id ==
                                          currentUser.id)
                                    TextButton(
                                      onPressed: () =>
                                          _buildInvoiceForm(context),
                                      child: const Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(CupertinoIcons
                                              .pencil_ellipsis_rectangle),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Edit')
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem('Date',
                        DateFormat('dd/MM/yyyy').format(widget.invoice.date!)),
                    _buildStringItem('Amount', widget.invoice.amount),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem(
                        'File Name', widget.invoice.caseFile!.fileName),
                    _buildStringItem('Paid', widget.invoice.totalPaid),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem(
                        'File Number', widget.invoice.caseFile!.fileNumber),
                    _buildStringItem('Balance', widget.invoice.balance),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildStringItem('Client', widget.invoice.client!.name),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem(
                        'Approver', widget.invoice.approver!.getName()),
                    InvoiceItemStatus(
                        name: status == 'SECONDARY_APPROVED'
                            ? 'Approved'
                            : status == 'SECONDARY_REJECTED'
                                ? 'Rejected'
                                : status == 'SECONDARY_RETURNED'
                                    ? 'Returned'
                                    : status
                                            .toLowerCase()
                                            .contains("primary approved")
                                        ? 'Primarily Approved'
                                        : status,
                        bgColor: status.toLowerCase().contains('approved')
                            ? AppColors.green
                            : status.toLowerCase().contains('rejected')
                                ? AppColors.red
                                : status.toLowerCase().contains('returned')
                                    ? AppColors.orange
                                    : status.toLowerCase().contains('paid')
                                        ? AppColors.purple
                                        : AppColors.blue,
                        horizontalPadding: 20,
                        verticalPadding: 5),
                  ],
                ),
              ],
            ),
    );
  }

  _buildStringItem(String title, String? data) {
    return SizedBox(
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
      builder: (context) => InvoiceForm(currencies: widget.currencies!),
    );
  }

  _approveInvoice() {
    setState(() {
      isProcessing = true;
      isLoading = true;
    });

    if (status == 'EDITED' || status == "SUBMITTED") {
      if (widget.invoice.canApprove ?? false) {
        _submitData("APPROVED", 'Invoice approved');
      } else if (widget.invoice.canApprove ?? false) {
        if (widget.invoice.secondApprover != null &&
            widget.invoice.secondApprover) {
          _submitData("SECONDARY_APPROVED", 'Invoice approved');
        } else {
          _submitData("PRIMARY_APPROVED", 'Invoice primarily approved');
        }
      }
    } else if (status == "PRIMARY_APPROVED") {
      _submitData("SECONDARY_APPROVED", 'Invoice approved');
    }
  }

  _submitData(String value, String toastText) {
    InvoiceApi.process({
      "forms": 1,
      "payout_amount": widget.invoice.amount!,
      "action_comment": "",
      "submit": value,
    }, widget.invoice.id!,
            onError: _onError, onSuccess: () => _onSuccess(toastText))
        .then((value) => _onSuccess(toastText))
        .onError((error, stackTrace) => _onError());
  }

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
