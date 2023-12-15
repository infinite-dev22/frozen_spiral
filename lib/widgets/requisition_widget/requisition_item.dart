import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:intl/intl.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:smart_case/database/requisition/requisition_model.dart';
import 'package:smart_case/widgets/requisition_widget/reuisition_item_status.dart';

import '../../data/global_data.dart';
import '../../models/smart_currency.dart';
import '../../pages/forms/requisition_form.dart';
import '../../services/apis/smartcase_apis/requisition_api.dart';
import '../../theme/color.dart';
import '../../util/smart_case_init.dart';

class RequisitionItem extends StatefulWidget {
  const RequisitionItem({
    super.key,
    required this.requisition,
    required this.color,
    required this.padding,
    this.showActions = false,
    this.showFinancialStatus = false,
    this.currencies,
  });

  final SmartRequisition requisition;
  final List<SmartCurrency>? currencies;

  final bool showActions;
  final Color color;
  final double padding;
  final bool showFinancialStatus;

  @override
  State<RequisitionItem> createState() => _RequisitionItemState();
}

class _RequisitionItemState extends State<RequisitionItem> {
  bool isProcessing = false;
  bool isLoading = false;

  NumberFormat formatter =
      NumberFormat('###,###,###,###,###,###,###,###,###.##');

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
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
                          (widget.requisition.canApprove == null &&
                                  (widget.requisition.canPay == false ||
                                      widget.requisition.canPay == null) &&
                                  (!widget.requisition.isMine! &&
                                          !widget.requisition.canEdit! &&
                                          widget.requisition.requisitionStatus!
                                                  .code !=
                                              'SUBMITTED' ||
                                      widget.requisition.requisitionStatus!
                                              .code !=
                                          'EDITED'))
                              ? Container()
                              : SizedBox(
                                  height: 33,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (widget.requisition.canApprove != null)
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
                                                    : _approveRequisition,
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
                                            TextButton(
                                              onPressed: isProcessing
                                                  ? null
                                                  : () => Navigator.pushNamed(
                                                        context,
                                                        '/requisition',
                                                        arguments: widget
                                                            .requisition.id!,
                                                      ).then((_) =>
                                                          setState(() {})),
                                              child: const Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.recycling_rounded,
                                                      size: 20),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text('Process')
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (widget.requisition.canPay == true)
                                        TextButton(
                                          onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/requisition',
                                            arguments: widget.requisition.id,
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
                                      if (widget.requisition.isMine! &&
                                              widget.requisition.canEdit! &&
                                              widget
                                                      .requisition
                                                      .requisitionStatus!
                                                      .code ==
                                                  'SUBMITTED' ||
                                          widget.requisition.requisitionStatus!
                                                  .code ==
                                              'EDITED')
                                        TextButton(
                                          onPressed: () =>
                                              _buildRequisitionForm(context),
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
                    _buildStringItem(
                        'File Name', widget.requisition.caseFile!.fileName),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.showFinancialStatus)
                      if (widget.requisition.caseFinancialStatus != null)
                        Column(
                          children: [
                            _buildFinancialStatusStringItem(
                                'Financial Status (UGX)',
                                formatter.format(double.parse(widget
                                    .requisition.caseFinancialStatus!
                                    .replaceAll(",", '')))),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem(
                            'Requisition Number', widget.requisition.number),
                        _buildStringItem('Category',
                            widget.requisition.requisitionCategory!.name),
                      ],
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(widget.requisition.date!),
                      style: const TextStyle(color: AppColors.inActiveColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildStringItem(
                        'Description', widget.requisition.description),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStringItem('Requestioner',
                            "${widget.requisition.employee!.firstName} ${widget.requisition.employee!.lastName}"),
                        _buildStringItem('Supervisor',
                            "${widget.requisition.supervisor!.firstName} ${widget.requisition.supervisor!.lastName}"),
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
                            formatter.format(
                                double.parse(widget.requisition.amount!))),
                        RequisitionItemStatus(
                            name: widget.requisition.requisitionStatus!.name ==
                                    'SECONDARY_APPROVED'
                                ? 'Approved'
                                : widget.requisition.requisitionStatus!.name ==
                                        'SECONDARY_REJECTED'
                                    ? 'Rejected'
                                    : widget.requisition.requisitionStatus!
                                                .name ==
                                            'SECONDARY_RETURNED'
                                        ? 'Returned'
                                        : widget.requisition.requisitionStatus!
                                            .name,
                            bgColor: widget.requisition.requisitionStatus!.name
                                    .toLowerCase()
                                    .contains('approved')
                                ? AppColors.green
                                : widget.requisition.requisitionStatus!.name
                                        .toLowerCase()
                                        .contains('rejected')
                                    ? AppColors.red
                                    : widget.requisition.requisitionStatus!.name
                                            .toLowerCase()
                                            .contains('returned')
                                        ? AppColors.orange
                                        : widget.requisition.requisitionStatus!
                                                .name
                                                .toLowerCase()
                                                .contains('paid')
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
                      (widget.requisition.canApprove == null &&
                              (widget.requisition.canPay == false ||
                                  widget.requisition.canPay == null) &&
                              ((!widget.requisition.isMine! ||
                                      widget.requisition.isMine!) &&
                                  (widget.requisition.canEdit! &&
                                      widget.requisition.employee!.id !=
                                          currentUser.id) &&
                                  (!widget.requisition.requisitionStatus!.code
                                          .toLowerCase()
                                          .contains('submit') ||
                                      (!widget.requisition.requisitionStatus!
                                              .code
                                              .toLowerCase()
                                              .contains('edit') &&
                                          widget.requisition.employee!.id !=
                                              currentUser.id) ||
                                      !widget
                                          .requisition.requisitionStatus!.code
                                          .toLowerCase()
                                          .contains("returned") ||
                                      (widget.requisition.requisitionStatus!
                                              .code
                                              .toLowerCase()
                                              .contains("returned") &&
                                          widget.requisition.employee!.id !=
                                              currentUser.id))))
                          ? Container()
                          : SizedBox(
                              height: 33,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (widget.requisition.canApprove != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: FilledButton(
                                            onPressed: (isProcessing)
                                                ? null
                                                : _approveRequisition,
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
                                        TextButton(
                                          onPressed: () => Navigator.pushNamed(
                                            context,
                                            '/requisition',
                                            arguments: widget.requisition.id!,
                                          ).then((_) => setState(() {})),
                                          child: const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.recycling_rounded,
                                                  size: 20),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text('Process')
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (widget.requisition.canPay == true)
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        '/requisition',
                                        arguments: widget.requisition.id,
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
                                  if ((widget.requisition.requisitionStatus!
                                              .code
                                              .toLowerCase()
                                              .contains('submit') ||
                                          widget.requisition.requisitionStatus!
                                              .code
                                              .toLowerCase()
                                              .contains('edit') ||
                                          widget.requisition.requisitionStatus!
                                              .code
                                              .toLowerCase()
                                              .contains("returned")) &&
                                      widget.requisition.employee!.id ==
                                          currentUser.id)
                                    TextButton(
                                      onPressed: () =>
                                          _buildRequisitionForm(context),
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
                _buildStringItem(
                    'File Name', widget.requisition.caseFile!.fileName),
                const SizedBox(
                  height: 10,
                ),
                if (widget.showFinancialStatus)
                  if (widget.requisition.caseFinancialStatus != null)
                    Column(
                      children: [
                        _buildFinancialStatusStringItem(
                            'Financial Status (UGX)',
                            formatter.format(double.parse(widget
                                .requisition.caseFinancialStatus!
                                .replaceAll(",", '')))),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem(
                        'Requisition Number', widget.requisition.number),
                    _buildStringItem('Category',
                        widget.requisition.requisitionCategory!.name),
                  ],
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(widget.requisition.date!),
                  style: const TextStyle(color: AppColors.inActiveColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildStringItem('Description', widget.requisition.description),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem('Requestioner',
                        "${widget.requisition.employee!.firstName} ${widget.requisition.employee!.lastName}"),
                    _buildStringItem('Supervisor',
                        "${widget.requisition.supervisor!.firstName} ${widget.requisition.supervisor!.lastName}"),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStringItem(
                        'Amount (${widget.requisition.currency!.code})',
                        formatter
                            .format(double.parse(widget.requisition.amount!))),
                    RequisitionItemStatus(
                        name: widget.requisition.requisitionStatus!.name,
                        // ==
                        //     'SECONDARY_APPROVED'
                        // ? 'Approved'
                        // : widget.requisition.requisitionStatus!.name ==
                        //         'SECONDARY_REJECTED'
                        //     ? 'Rejected'
                        //     : widget.requisition.requisitionStatus!.name ==
                        //             'SECONDARY_RETURNED'
                        //         ? 'Returned'
                        //         : widget.requisition.requisitionStatus!.name
                        //                 .toLowerCase()
                        //                 .contains("primary approved")
                        //             ? 'Primarily Approved'
                        //             : widget.requisition.requisitionStatus!
                        //                 .name,
                        bgColor: widget.requisition.requisitionStatus!.name
                                .toLowerCase()
                                .contains('approved')
                            ? AppColors.green
                            : widget.requisition.requisitionStatus!.name
                                    .toLowerCase()
                                    .contains('rejected')
                                ? AppColors.red
                                : widget.requisition.requisitionStatus!.name
                                        .toLowerCase()
                                        .contains('returned')
                                    ? AppColors.orange
                                    : widget.requisition.requisitionStatus!.name
                                            .toLowerCase()
                                            .contains('paid')
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
    return Column(
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
          highlightStyle: const TextStyle(
            // fontSize: 14,
            // fontWeight: FontWeight.bold,
            color: AppColors.darker,
            backgroundColor: AppColors.searchText,
          ),
        ),
      ],
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
              color: (double.parse(widget.requisition.caseFinancialStatus!
                          .replaceAll(",", '')) >
                      0)
                  ? AppColors.green
                  : (double.parse(widget.requisition.caseFinancialStatus!
                              .replaceAll(",", '')) ==
                          0)
                      ? AppColors.blue
                      : AppColors.red),
        ),
      ],
    );
  }

  _buildRequisitionForm(BuildContext context) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => RequisitionForm(
          currencies: widget.currencies!, requisition: widget.requisition),
    );
  }

  _approveRequisition() {
    setState(() {
      isProcessing = true;
      isLoading = true;
    });

    if (widget.requisition.requisitionStatus!.code == 'EDITED' ||
        widget.requisition.requisitionStatus!.code == "SUBMITTED") {
      if (widget.requisition.canApprove == 'LV1') {
        _submitData("APPROVED", 'Requisition approved');
      } else if (widget.requisition.canApprove == 'LV2') {
        if (widget.requisition.secondApprover != null &&
            widget.requisition.secondApprover) {
          _submitData("SECONDARY_APPROVED", 'Requisition approved');
        } else {
          _submitData("PRIMARY_APPROVED", 'Requisition primarily approved');
        }
      }
    } else if (widget.requisition.requisitionStatus!.code ==
        "PRIMARY_APPROVED") {
      _submitData("SECONDARY_APPROVED", 'Requisition approved');
    }
  }

  _submitData(String value, String toastText) {
    RequisitionApi.process({
      "forms": 1,
      "payout_amount": widget.requisition.amount!,
      "action_comment": "",
      "submit": value,
    }, widget.requisition.id!,
            onError: _onError, onSuccess: () => _onSuccess(toastText))
        .then((value) => _onSuccess(toastText))
        .onError((error, stackTrace) => _onError());
  }

  _onSuccess(String text) async {
    RequisitionApi.fetchAll().then((value) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        desc: 'Requisition has been successfully approved',
        autoHide: const Duration(seconds: 3),
        btnCancel: null,
        // btnOkOnPress: () {},
      ).show();
      isProcessing = false;
      preloadedRequisitions.remove(widget.requisition);
      isLoading = false;
      setState(() {});
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
}
