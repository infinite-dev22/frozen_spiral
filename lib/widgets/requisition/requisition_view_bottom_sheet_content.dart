import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:smart_case/models/smart_requisition.dart';
import 'package:smart_case/services/apis/smartcase_api.dart';
import 'package:smart_case/widgets/custom_textbox.dart';
import 'package:smart_case/widgets/requisition/requisition_item.dart';

import '../../theme/color.dart';
import '../../util/smart_case_init.dart';
import '../custom_appbar.dart';

class RequisitionViewBottomSheetContent extends StatefulWidget {
  const RequisitionViewBottomSheetContent({super.key});

  @override
  State<RequisitionViewBottomSheetContent> createState() =>
      _RequisitionViewBottomSheetContentState();
}

class _RequisitionViewBottomSheetContentState
    extends State<RequisitionViewBottomSheetContent> {
  late Requisition requisition;

  TextEditingController commentController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool isHeadElevated = false;

  @override
  Widget build(BuildContext context) {
    requisition = ModalRoute.of(context)!.settings.arguments as Requisition;

    return Scaffold(
      backgroundColor: AppColors.appBgColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: AppColors.white,
        ),
        backgroundColor: AppColors.primary,
        title:
            AppBarContent(isNetwork: currentUser.avatar != null ? true : false),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final ScrollController scrollController = ScrollController();
    return Column(
      children: [
        _buildHead('Process Requisition'),
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                RequisitionItem(
                  color: AppColors.white,
                  padding: 10,
                  requisition: requisition,
                ),
                _buildAmountHolder('10,000'),
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

  Widget _buildAmountHolder(String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.textBoxColor),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: SizedBox(
        height: 50,
        child: TextFormField(
          decoration: InputDecoration(
            label: const Text(
              'Amount',
              style: TextStyle(color: AppColors.inActiveColor, fontSize: 18),
            ),
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
            CurrencyInputFormatter(),
          ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FilledButton(
          onPressed: _approveRequisition,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => AppColors.green),
          ),
          child: const Text(
            'Approve',
          ),
        ),
        FilledButton(
          onPressed: _returnRequisition,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => AppColors.orange),
          ),
          child: const Text(
            'Return',
          ),
        ),
        FilledButton(
          onPressed: _rejectRequisition,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.resolveWith((states) => AppColors.red),
          ),
          child: const Text(
            'Reject',
          ),
        ),
      ],
    );
  }

  _approveRequisition() {
    if (requisition.canApprove == 'LV1') {
      SmartCaseApi.smartPost(
          'api/accounts/requisitions/${requisition.caseFile.id}/process',
          currentUser.token, {
        "forms": 1,
        "payout_amount": amountController.text.trim(),
        "action_comment": commentController.text.trim(),
        "submit": "APPROVED"
      });
    } else if (requisition.canApprove == 'LV2') {
      if (requisition.requisitionStatus.code == "SUBMITTED") {
        SmartCaseApi.smartPost(
            'api/accounts/requisitions/${requisition.caseFile.id}/process',
            currentUser.token, {
          "forms": 1,
          "payout_amount": amountController.text.trim(),
          "action_comment": commentController.text.trim(),
          "submit": "PRIMARY_APPROVED"
        });
      } else if (requisition.requisitionStatus.code == "PRIMARY_APPROVED") {
        SmartCaseApi.smartPost(
            'api/accounts/requisitions/${requisition.caseFile.id}/process',
            currentUser.token, {
          "forms": 1,
          "payout_amount": amountController.text.trim(),
          "action_comment": commentController.text.trim(),
          "submit": "APPROVED"
        });
      }
    }
  }

  _returnRequisition() {
    if (requisition.canApprove == 'LVL1') {
      SmartCaseApi.smartPost(
          'api/accounts/requisitions/${requisition.caseFile.id}/process',
          currentUser.token, {
        "forms": 1,
        "payout_amount": amountController.text.trim(),
        "action_comment": commentController.text.trim(),
        "submit": "RETURNED"
      });
    } else if (requisition.canApprove == 'LVL2') {
      if (requisition.requisitionStatus.code == "SUBMITTED") {
        SmartCaseApi.smartPost(
            'api/accounts/requisitions/${requisition.caseFile.id}/process',
            currentUser.token, {
          "forms": 1,
          "payout_amount": amountController.text.trim(),
          "action_comment": commentController.text.trim(),
          "submit": "PRIMARY_RETURNED"
        });
      } else if (requisition.requisitionStatus.code == "PRIMARY_RETURNED") {
        SmartCaseApi.smartPost(
            'api/accounts/requisitions/${requisition.caseFile.id}/process',
            currentUser.token, {
          "forms": 1,
          "payout_amount": amountController.text.trim(),
          "action_comment": commentController.text.trim(),
          "submit": "RETURNED"
        });
      }
    }
  }

  _rejectRequisition() {
    if (requisition.canApprove == 'LVL1') {
      SmartCaseApi.smartPost(
          'api/accounts/requisitions/${requisition.caseFile.id}/process',
          currentUser.token, {
        "forms": 1,
        "payout_amount": amountController.text.trim(),
        "action_comment": commentController.text.trim(),
        "submit": "REJECTED"
      });
    } else if (requisition.canApprove == 'LVL2') {
      if (requisition.requisitionStatus.code == "SUBMITTED") {
        SmartCaseApi.smartPost(
            'api/accounts/requisitions/${requisition.caseFile.id}/process',
            currentUser.token, {
          "forms": 1,
          "payout_amount": amountController.text.trim(),
          "action_comment": commentController.text.trim(),
          "submit": "PRIMARY_REJECTED"
        });
      } else if (requisition.requisitionStatus.code == "PRIMARY_REJECTED") {
        SmartCaseApi.smartPost(
            'api/accounts/requisitions/${requisition.caseFile.id}/process',
            currentUser.token, {
          "forms": 1,
          "payout_amount": amountController.text.trim(),
          "action_comment": commentController.text.trim(),
          "submit": "REJECTED"
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    amountController.text = requisition.amount;

    super.setState(fn);
  }
}
