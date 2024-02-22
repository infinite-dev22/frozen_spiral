import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';

class InvoiceViewPage extends StatefulWidget {
  const InvoiceViewPage({super.key});

  @override
  State<InvoiceViewPage> createState() => _InvoiceViewPageState();
}

class _InvoiceViewPageState extends State<InvoiceViewPage> {
  SmartInvoice? invoice;
  late int invoiceId;
  var status;
  final _key = GlobalKey();

  TextEditingController commentController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  SmartDrawer? drawer;
  bool isHeadElevated = false;
  NumberFormat formatter =
      NumberFormat('###,###,###,###,###,###,###,###,###.##');

  @override
  Widget build(BuildContext context) {
    try {
      String invoiceIdAsString =
          ModalRoute.of(context)!.settings.arguments as String;
      invoiceId = int.parse(invoiceIdAsString);
    } catch (e) {
      invoiceId = ModalRoute.of(context)!.settings.arguments as int;
    }

    if (invoice == null) {
      _setupData();
    }

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title: AppBarContent(
          isNetwork: currentUser.avatar != null ? true : false,
          canNavigate: true,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return (invoice != null)
        ? Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
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
              color: AppColors.white,
            ),
            child: Column(
              children: [
                const Text("DISBURSEMENT NOTE"),
                _textItem("Name", "MISS MARISOL PFANNERSTILL"),
                _textItem("Currency", "Euro (EUR)"),
                _textItem("Amount /Tax Inc", "709,298.00 (EUR)"),
                _textItem("Paid", "0.00 (EUR)"),
                _textItem("Balance", "709,298.00 (EUR)"),
                _textItem("Done by", "Mr Mark Jonathan"),
                _textItem("Supervisor", "Anna Sthesia."),
                _textItem("Case file", "Darrion Mitchell VS Brannon Roob"),
                _textItem("Practice Area", "Employment"),
                _textItem("Date", "19/02/2024"),
                _textItem("Due Date", " 21/02/2024"),
                _textItem("Status", "Submitted"),
                _textItem("Invoice Number", "DN/2/024"),
                _textItem(
                    "Billing Address",
                    "MISS MARISOL PFANNERSTILL\n"
                        "7273 PRUDENCE FORKS NEW KEYONVILLE, UT 37693"),
                _textItem(
                    "BANK",
                    "Account Name: Training & Co. Advocates\n"
                        "Account No.: 01234567890\n"
                        "Bank: STANBIC\n"
                        "Currency:UGX\n"
                        "Swift Code: UGX0034EDX"),
                _textItem(
                    "AYMENT TERMS",
                    "1. Accounts carry interest at 6% effective one month from the date of receipt hereof R:6)\n"
                        "2. Under the VAT Statute 1996, 18% is payable on all fees."),
              ],
            ),
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.gray45,
              radius: 20,
            ),
          );
  }

  Widget _buildBody1() {
    return (invoice != null)
        ? Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
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
              color: AppColors.white,
            ),
            child: Column(
              children: [
                const Text("DISBURSEMENT NOTE"),
                _textItem("Name", "MISS MARISOL PFANNERSTILL"),
                _textItem("Currency", "Euro (EUR)"),
                _textItem("Amount /Tax Inc", "709,298.00 (EUR)"),
                _textItem("Paid", "0.00 (EUR)"),
                _textItem("Balance", "709,298.00 (EUR)"),
                _textItem("Done by", "Mr Mark Jonathan"),
                _textItem("Supervisor", "Anna Sthesia."),
                _textItem("Case file", "Darrion Mitchell VS Brannon Roob"),
                _textItem("Practice Area", "Employment"),
                _textItem("Date", "19/02/2024"),
                _textItem("Due Date", " 21/02/2024"),
                _textItem("Status", "Submitted"),
                _textItem("Invoice Number", "DN/2/024"),
                _textItem(
                    "Billing Address",
                    "MISS MARISOL PFANNERSTILL\n"
                        "7273 PRUDENCE FORKS NEW KEYONVILLE, UT 37693"),
                _textItem(
                    "BANK",
                    "Account Name: Training & Co. Advocates\n"
                        "Account No.: 01234567890\n"
                        "Bank: STANBIC\n"
                        "Currency:UGX\n"
                        "Swift Code: UGX0034EDX"),
                _textItem(
                    "AYMENT TERMS",
                    "1. Accounts carry interest at 6% effective one month from the date of receipt hereof R:6)\n"
                        "2. Under the VAT Statute 1996, 18% is payable on all fees."),
              ],
            ),
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.gray45,
              radius: 20,
            ),
          );
  }

  Widget _textItem(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$title:"),
        Text(data),
      ],
    );
  }

  Widget _buildButtons() {
    return (invoice!.canPay == true)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: (drawer != null &&
                        (drawer!.openingBalance! > 0 &&
                            drawer!.openingBalance! >=
                                double.parse(
                                    amountController.text.replaceAll(",", ""))))
                    ? _payoutInvoice
                    : (preloadedDrawers.isEmpty)
                        ? _payoutInvoice
                        : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (drawer != null &&
                          (drawer!.openingBalance! > 0 &&
                              drawer!.openingBalance! >=
                                  double.parse(amountController.text
                                      .replaceAll(",", "")))) {
                        return AppColors.green;
                      } else if (preloadedDrawers.isEmpty) {
                        return AppColors.green;
                      } else {
                        return Colors.green.shade200;
                      }
                    },
                  ),
                ),
                child: Text(
                  (drawer != null &&
                          (drawer!.openingBalance! > 0 &&
                              drawer!.openingBalance! >=
                                  double.parse(amountController.text
                                      .replaceAll(",", ""))))
                      ? 'Pay out'
                      : 'Select drawer with sufficient funds to continue',
                ),
              ),
            ],
          )
        : (invoice!.canApprove != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _approveInvoice,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.green),
                    ),
                    child: const Text(
                      'Approve',
                    ),
                  ),
                  FilledButton(
                    onPressed: _returnInvoice,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.orange),
                    ),
                    child: const Text(
                      'Return',
                    ),
                  ),
                  FilledButton(
                    onPressed: _rejectInvoice,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.red),
                    ),
                    child: const Text(
                      'Reject',
                    ),
                  ),
                ],
              )
            : Container();
  }

  _payoutInvoice() {
    _submitData("PAID", 'Pay out successful');

    Navigator.pop(context, _key);
  }

  _approveInvoice() {
    if (invoice!.invoiceStatus2!.code == 'EDITED' ||
        invoice!.invoiceStatus2!.code == "SUBMITTED") {
      if (invoice!.canApprove ?? false) {
        _submitData("APPROVED", 'Invoice approved');
      } else if (invoice!.canApprove ?? false) {
        if (invoice!.secondApprover != null && invoice!.secondApprover) {
          _submitData("SECONDARY_APPROVED", 'Invoice approved');
        } else {
          _submitData("PRIMARY_APPROVED", 'Invoice primarily approved');
        }
      }
    } else if (invoice!.invoiceStatus2!.code == "PRIMARY_APPROVED") {
      _submitData("SECONDARY_APPROVED", 'Invoice approved');
    }

    Navigator.pop(context);
  }

  _returnInvoice() {
    if (invoice!.invoiceStatus2!.code == 'EDITED' ||
        invoice!.invoiceStatus2!.code == "SUBMITTED") {
      if (invoice!.canApprove ?? false) {
        _submitData("RETURNED", 'Action successful');
      } else if (invoice!.canApprove ?? false) {
        _submitData("PRIMARY_RETURNED", 'Action successful');
      }
    } else if (invoice!.invoiceStatus2!.code == "PRIMARY_RETURNED") {
      _submitData("SECONDARY_RETURNED", 'Action successful');
    }

    Navigator.pop(context);
  }

  _rejectInvoice() {
    if (invoice!.invoiceStatus2!.code == 'EDITED' ||
        invoice!.invoiceStatus2!.code == "SUBMITTED") {
      if (invoice!.canApprove ?? false) {
        _submitData("REJECTED", 'Action successful');
      } else if (invoice!.canApprove ?? false) {
        _submitData("PRIMARY_REJECTED", 'Action successful');
      }
    } else if (invoice!.invoiceStatus2!.code == "PRIMARY_REJECTED") {
      _submitData("SECONDARY_REJECTED", 'Action successful');
    }

    Navigator.pop(context);
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
    preloadedInvoices.removeWhere((element) => element.id == invoice!.id);
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

  _submitData(String value, String toastText) {
    SmartCaseApi.smartPost(
      'api/accounts/invoices/${invoice!.id}/process',
      currentUser.token,
      {
        if (drawer != null) "drawer_id": drawer!.id,
        "payout_amount": amountController.text.trim(),
        "action_comment": commentController.text.trim(),
        "submit": value,
      },
      onSuccess: () => _onSuccess(toastText),
      onError: _onError,
    );
  }

  _setupData() async {
    await InvoiceApi.fetch(invoiceId, onError: () {
      _onError();
    }).then((invoice) {
      this.invoice = invoice;
      // amountController.text = formatter.format(double.parse(invoice!.amount!));
      if (mounted) setState(() {});
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
}
