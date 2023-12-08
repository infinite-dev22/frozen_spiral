import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/models/smart_drawer.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/services/apis/smartcase_apis/requisition_api.dart';
import 'package:smart_case/widgets/custom_dropdowns.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/requisition_widget/requisition_item.dart';

import '../data/global_data.dart';
import '../theme/color.dart';
import '../util/smart_case_init.dart';
import '../widgets/custom_appbar.dart';

class RequisitionViewPage extends StatefulWidget {
  const RequisitionViewPage({super.key});

  @override
  State<RequisitionViewPage> createState() => _RequisitionViewPageState();
}

class _RequisitionViewPageState extends State<RequisitionViewPage> {
  SmartRequisition? requisition;
  late int requisitionId;
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
      String requisitionIdAsString =
          ModalRoute.of(context)!.settings.arguments as String;
      requisitionId = int.parse(requisitionIdAsString);
    } catch (e) {
      requisitionId = ModalRoute.of(context)!.settings.arguments as int;
    }

    if (requisition == null) {
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
    return (requisition != null)
        ? Column(
            children: [
              _buildHead('Process Requisition'),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8),
                    children: [
                      RequisitionItem(
                        color: AppColors.white,
                        padding: 10,
                        requisition: requisition!,
                        showFinancialStatus: true,
                      ),
                      _buildAmountHolder(),
                      if (preloadedDrawers.isNotEmpty &&
                          requisition!.canPay == true)
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
              ((requisition!.requisitionStatus!.code == "PRIMARY_APPROVED" &&
                          requisition!.requisitionStatus!.code == "APPROVED") ||
                      requisition!.requisitionStatus!.code == "APPROVED")
                  ? true
                  : false,
          enabled:
              ((requisition!.requisitionStatus!.code == "PRIMARY_APPROVED" &&
                          requisition!.requisitionStatus!.code == "APPROVED") ||
                      requisition!.requisitionStatus!.code == "APPROVED")
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
    return (requisition!.canPay == true)
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
                    ? _payoutRequisition
                    : (preloadedDrawers.isEmpty)
                        ? _payoutRequisition
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
        : (requisition!.canApprove != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: _approveRequisition,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.green),
                    ),
                    child: const Text(
                      'Approve',
                    ),
                  ),
                  FilledButton(
                    onPressed: _returnRequisition,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => AppColors.orange),
                    ),
                    child: const Text(
                      'Return',
                    ),
                  ),
                  FilledButton(
                    onPressed: _rejectRequisition,
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

  _payoutRequisition() {
    _submitData("PAID", 'Pay out successful');

    Navigator.pop(context, _key);
  }

  _approveRequisition() {
    if (requisition!.requisitionStatus!.code == 'EDITED' ||
        requisition!.requisitionStatus!.code == "SUBMITTED") {
      if (requisition!.canApprove == 'LV1') {
        _submitData("APPROVED", 'Requisition approved');
      } else if (requisition!.canApprove == 'LV2') {
        if (requisition!.secondApprover != null &&
            requisition!.secondApprover) {
          _submitData("SECONDARY_APPROVED", 'Requisition approved');
        } else {
          _submitData("PRIMARY_APPROVED", 'Requisition primarily approved');
        }
      }
    } else if (requisition!.requisitionStatus!.code == "PRIMARY_APPROVED") {
      _submitData("SECONDARY_APPROVED", 'Requisition approved');
    }

    Navigator.pop(context);
  }

  _returnRequisition() {
    if (requisition!.requisitionStatus!.code == 'EDITED' ||
        requisition!.requisitionStatus!.code == "SUBMITTED") {
      if (requisition!.canApprove == 'LV1') {
        _submitData("RETURNED", 'Action successful');
      } else if (requisition!.canApprove == 'LV2') {
        _submitData("PRIMARY_RETURNED", 'Action successful');
      }
    } else if (requisition!.requisitionStatus!.code == "PRIMARY_RETURNED") {
      _submitData("SECONDARY_RETURNED", 'Action successful');
    }

    Navigator.pop(context);
  }

  _rejectRequisition() {
    if (requisition!.requisitionStatus!.code == 'EDITED' ||
        requisition!.requisitionStatus!.code == "SUBMITTED") {
      if (requisition!.canApprove == 'LV1') {
        _submitData("REJECTED", 'Action successful');
      } else if (requisition!.canApprove == 'LV2') {
        _submitData("PRIMARY_REJECTED", 'Action successful');
      }
    } else if (requisition!.requisitionStatus!.code == "PRIMARY_REJECTED") {
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
    // preloadedRequisitions.remove(requisition);
    preloadedRequisitions
        .removeWhere((element) => element.id == requisition!.id);
  }

  _onError() async {
    refreshRequisitions = true;

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
      'api/accounts/requisitions/${requisition!.id}/process',
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
    await RequisitionApi.fetch(requisitionId, onError: () {
      _onError();
    }).then((requisition) {
      this.requisition = requisition;
      amountController.text =
          formatter.format(double.parse(requisition!.amount!));
      if (mounted) setState(() {});
    });
  }
}
