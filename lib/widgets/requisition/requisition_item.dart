import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_requisition.dart';
import 'package:smart_case/widgets/requisition/reuisition_item_status.dart';

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

  final Requisition requisition;
  final List<SmartCurrency>? currencies;

  final bool showActions;
  final Color color;
  final double padding;
  final bool showFinancialStatus;

  @override
  State<RequisitionItem> createState() => _RequisitionItemState();
}

class _RequisitionItemState extends State<RequisitionItem> {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    if (widget.requisition.canPay == true) print('${widget.requisition.number} - ${widget.requisition.canPay}');
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
                SizedBox(
                  height: 33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (widget.requisition.canApprove != null)
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                                  context, '/requisition',
                                  arguments: widget.requisition)
                              .then((_) => setState(() {})),
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
                      (widget.requisition.canPay == true)
                          ? TextButton(
                              onPressed: () => Navigator.pushNamed(
                                      context, '/requisition',
                                      arguments: widget.requisition)
                                  .then((_) => setState(() {})),
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
                            )
                          : Container(),
                      if (widget.requisition.isMine &&
                              widget.requisition.canEdit &&
                              widget.requisition.requisitionStatus.code ==
                                  'SUBMITTED' ||
                          widget.requisition.requisitionStatus.code == 'EDITED')
                        TextButton(
                          onPressed: () => _buildRequisitionForm(context),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.pencil_ellipsis_rectangle),
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
          _buildStringItem('File Name', widget.requisition.caseFile.fileName),
          const SizedBox(
            height: 10,
          ),
          if (widget.showFinancialStatus)
            Column(
              children: [
                _buildStringItem('Financial Status',
                    widget.requisition.requisitionStatus.code),
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
                  'Category', widget.requisition.requisitionCategory),
            ],
          ),
          Text(
            DateFormat('dd/MM/yyyy').format(widget.requisition.date),
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
                  "${widget.requisition.employee.firstName} ${widget.requisition.employee.lastName}"),
              _buildStringItem('Supervisor',
                  "${widget.requisition.supervisor.firstName} ${widget.requisition.supervisor.lastName}"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Amount', widget.requisition.amount),
              RequisitionItemStatus(
                  name: widget.requisition.requisitionStatus.name,
                  bgColor: Colors.green,
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
