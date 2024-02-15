import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/data/app_config.dart';
import 'package:smart_case/database/drawer/drawer_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_item.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/invoice_api.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/widgets/custom_appbar.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_textbox.dart';

class InvoiceViewPage extends StatefulWidget {
  const InvoiceViewPage({super.key});

  @override
  State<InvoiceViewPage> createState() => _InvoiceViewPageState();
}

class _InvoiceViewPageState extends State<InvoiceViewPage> {
  SmartInvoice? invoice;
  late int invoiceId;
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
    final ScrollController scrollController = ScrollController();
    return (invoice != null)
        ? Column(
            children: [
              _buildHead('Process Invoice'),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8),
                    children: [
                      InvoiceItem(
                        color: AppColors.white,
                        padding: 10,
                        invoice: invoice!,
                        showFinancialStatus: true,
                      ),
                      _buildAmountHolder(),
                      if (preloadedDrawers.isNotEmpty &&
                          invoice!.canPay == true)
                        _buildDrawers(),
                      CustomTextArea(
                        hint: "Add comments",
                        controller: commentController,
                      ),
                      const SizedBox(height: 20),
                      _buildButtons(),
                    ],
                  ),
                ),
              ),
            ],
          )
        : const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.gray45,
              radius: 20,
            ),
          );
  }

  Widget _buildHead(String name) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0.0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildDrawers() {
    return CustomGenericDropdown(
      hintText: "Select drawer",
      menuItems: preloadedDrawers,
      onChanged: (drawer) => setState(() {
        this.drawer = drawer;
      }),
    );
  }

  Widget _buildAmountHolder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.textBoxColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.textBoxColor,
            hintStyle:
                const TextStyle(color: AppColors.inActiveColor, fontSize: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            CurrencyInputFormatter(mantissaLength: 0),
          ],
          readOnly:
              ((invoice!.invoiceStatus!.code == "PRIMARY_APPROVED" &&
                          invoice!.invoiceStatus!.code == "APPROVED") ||
                      invoice!.invoiceStatus!.code == "APPROVED")
                  ? true
                  : false,
          enabled:
              ((invoice!.invoiceStatus!.code == "PRIMARY_APPROVED" &&
                          invoice!.invoiceStatus!.code == "APPROVED") ||
                      invoice!.invoiceStatus!.code == "APPROVED")
                  ? false
                  : true,
          controller: amountController,
          autofocus: false,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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
    if (invoice!.invoiceStatus!.code == 'EDITED' ||
        invoice!.invoiceStatus!.code == "SUBMITTED") {
      if (invoice!.canApprove == 'LV1') {
        _submitData("APPROVED", 'Invoice approved');
      } else if (invoice!.canApprove == 'LV2') {
        if (invoice!.secondApprover != null &&
            invoice!.secondApprover) {
          _submitData("SECONDARY_APPROVED", 'Invoice approved');
        } else {
          _submitData("PRIMARY_APPROVED", 'Invoice primarily approved');
        }
      }
    } else if (invoice!.invoiceStatus!.code == "PRIMARY_APPROVED") {
      _submitData("SECONDARY_APPROVED", 'Invoice approved');
    }

    Navigator.pop(context);
  }

  _returnInvoice() {
    if (invoice!.invoiceStatus!.code == 'EDITED' ||
        invoice!.invoiceStatus!.code == "SUBMITTED") {
      if (invoice!.canApprove == 'LV1') {
        _submitData("RETURNED", 'Action successful');
      } else if (invoice!.canApprove == 'LV2') {
        _submitData("PRIMARY_RETURNED", 'Action successful');
      }
    } else if (invoice!.invoiceStatus!.code == "PRIMARY_RETURNED") {
      _submitData("SECONDARY_RETURNED", 'Action successful');
    }

    Navigator.pop(context);
  }

  _rejectInvoice() {
    if (invoice!.invoiceStatus!.code == 'EDITED' ||
        invoice!.invoiceStatus!.code == "SUBMITTED") {
      if (invoice!.canApprove == 'LV1') {
        _submitData("REJECTED", 'Action successful');
      } else if (invoice!.canApprove == 'LV2') {
        _submitData("PRIMARY_REJECTED", 'Action successful');
      }
    } else if (invoice!.invoiceStatus!.code == "PRIMARY_REJECTED") {
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
    preloadedInvoices
        .removeWhere((element) => element.id == invoice!.id);
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
      amountController.text =
          formatter.format(double.parse(invoice!.amount!));
      if (mounted) setState(() {});
    });
  }
}
