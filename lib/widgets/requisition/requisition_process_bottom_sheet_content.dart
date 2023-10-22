import 'package:flutter/material.dart';
import 'package:smart_case/widgets/requisition/requisition_item.dart';

import '../custom_textbox.dart';

class RequisitionProcessBottomSheetContent extends StatefulWidget {
  const RequisitionProcessBottomSheetContent({super.key});

  @override
  State<RequisitionProcessBottomSheetContent> createState() =>
      _RequisitionProcessBottomSheetContentState();
}

class _RequisitionProcessBottomSheetContentState
    extends State<RequisitionProcessBottomSheetContent> {
  final TextEditingController descriptionController = TextEditingController();
  final globalKey = GlobalKey();

  String fileName = 'Data here';
  String requisitionNumber = 'Data here';
  String dateCreated = 'Data here';
  Color color = Colors.green;
  double padding = 10;
  String status = 'Data here';
  String category = 'Data here';
  String description = 'Data here';
  String requesterName = 'Data here';
  String supervisorName = 'Data here';
  String amount = 'Data here';

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        RequisitionItem(
          fileName: fileName,
          requisitionNumber: requisitionNumber,
          dateCreated: dateCreated,
          color: color,
          padding: padding,
          status: status,
          category: category,
          description: description,
          requesterName: requesterName,
          supervisorName: supervisorName,
          amount: amount,
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            Text('Payout amount'),
            Text(amount),
          ],
        ),
        const SizedBox(height: 10),
        CustomTextArea(
          key: globalKey,
          hint: 'Description',
          controller: descriptionController,
          onTap: () {
            Scrollable.ensureVisible(globalKey.currentContext!);
          },
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Text('Approve'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Return'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Process'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Pay out'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Reject'),
            ),
          ],
        ),
      ],
    );
  }
}
