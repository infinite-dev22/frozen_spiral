import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_case/models/smart_requisition.dart';
import 'package:smart_case/widgets/requisition/reuisition_item_status.dart';

import '../../models/smart_currency.dart';
import '../../pages/forms/requisition_form.dart';
import '../../theme/color.dart';

class RequisitionItem extends StatelessWidget {
  const RequisitionItem({
    super.key,
    required this.requisition,
    required this.color,
    required this.padding,
    this.showActions = true,
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
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        padding,
        (showActions) ? 0 : padding,
        padding,
        padding,
      ),
      margin: EdgeInsets.only(bottom: padding),
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
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showActions)
            Column(
              children: [
                SizedBox(
                  height: 33,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (requisition.canApprove != null)
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/requisition',
                              arguments: requisition),
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
                      if (requisition.canPay != null && requisition.canPay!)
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/requisition'),
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
                      if (requisition.isMine &&
                              requisition.canEdit &&
                              requisition.requisitionStatus.code ==
                                  'SUBMITTED' ||
                          requisition.requisitionStatus.code == 'EDITED')
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
          _buildStringItem('File Name', requisition.caseFile.fileName),
          const SizedBox(
            height: 10,
          ),
          if (showFinancialStatus)
            Column(
              children: [
                _buildStringItem(
                    'Financial Status', requisition.requisitionStatus.code),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Requisition Number', requisition.number),
              _buildStringItem('Category', requisition.requisitionCategory),
            ],
          ),
          Text(
            DateFormat('dd/MM/yyyy').format(requisition.date),
            style: const TextStyle(color: AppColors.inActiveColor),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildStringItem('Description', requisition.description),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Requester',
                  "${requisition.employee.firstName} ${requisition.employee.lastName}"),
              _buildStringItem('Supervisor',
                  "${requisition.supervisor.firstName} ${requisition.supervisor.lastName}"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStringItem('Amount', requisition.amount),
              RequisitionItemStatus(
                  name: requisition.requisitionStatus.name,
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
      builder: (context) => RequisitionForm(currencies: currencies!),
    );
  }
}
