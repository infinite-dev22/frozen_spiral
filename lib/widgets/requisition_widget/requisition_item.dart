import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_requisition.dart';
import 'package:smart_case/widgets/requisition_widget/reuisition_item_status.dart';

import '../../models/smart_currency.dart';
import '../../pages/forms/requisition_form.dart';
import '../../theme/color.dart';

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
      child: Column(
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
                                widget.requisition.requisitionStatus!.code !=
                                    'SUBMITTED' ||
                            widget.requisition.requisitionStatus!.code !=
                                'EDITED'))
                    ? Container()
                    : SizedBox(
                        height: 33,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.requisition.canApprove != null)
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/requisition',
                                  arguments: widget.requisition.id!,
                                ).then((_) => setState(() {})),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.recycling_rounded),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('Process')
                                  ],
                                ),
                              ),
                            if (widget.requisition.canPay == true)
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/requisition',
                                  arguments: widget.requisition.id,
                                ).then((_) => setState(() {})),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                    widget.requisition.requisitionStatus!
                                            .code ==
                                        'SUBMITTED' ||
                                widget.requisition.requisitionStatus!.code ==
                                    'EDITED')
                              TextButton(
                                onPressed: () => _buildRequisitionForm(context),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
          _buildStringItem('File Name', widget.requisition.caseFile!.fileName),
          const SizedBox(
            height: 10,
          ),
          if (widget.showFinancialStatus)
            if (widget.requisition.caseFinancialStatus != null)
              Column(
                children: [
                  _buildFinancialStatusStringItem(
                      'Financial Status (UGX)',
                      formatter.format(double.parse(
                          widget.requisition.caseFinancialStatus.toString()))),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Requisition Number', widget.requisition.number),
              _buildStringItem(
                  'Category', widget.requisition.requisitionCategory!.name),
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
              _buildStringItem('Requester',
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
              _buildStringItem('Amount (UGX)',
                  formatter.format(double.parse(widget.requisition.amount!))),
              RequisitionItemStatus(
                  name: widget.requisition.requisitionStatus!.name ==
                          'SECONDARY_APPROVED'
                      ? 'Approved'
                      : widget.requisition.requisitionStatus!.name ==
                              'SECONDARY_REJECTED'
                          ? 'Rejected'
                          : widget.requisition.requisitionStatus!.name ==
                                  'SECONDARY_RETURNED'
                              ? 'Returned'
                              : widget.requisition.requisitionStatus!.name,
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
        Text(
          data ?? 'Null',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
              color: (double.parse(
                          widget.requisition.caseFinancialStatus.toString()) >
                      0)
                  ? AppColors.green
                  : (double.parse(widget.requisition.caseFinancialStatus
                              .toString()) ==
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
}
