import 'package:flutter/material.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/pages/invoice_page/widgets/new/invoice_item_status.dart';
import 'package:smart_case/theme/color.dart';
import 'package:smart_case/util/smart_case_init.dart';
import 'package:smart_case/util/utilities.dart';
import 'package:smart_case/widgets/text_item.dart';

class InfoWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const InfoWidget({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: AppColors.white,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextItem(title: "Invoice No.", data: invoice.number ?? "N/A"),
                TextItem(
                    title: "Date",
                    data: invoice.date == null
                        ? "N/A"
                        : formatDateTimeToString(invoice.date)),
                TextItem(
                    title: "Supervisor",
                    data: invoice.approver == null
                        ? "N/A"
                        : invoice.approver!.getName()),
                TextItem(
                    title: "File",
                    data:
                        invoice.file == null ? "N/A" : invoice.file!.getName()),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextItem(title: "Done By", data: (invoice.employee ?? currentUser).getName()),
                TextItem(
                  title: "Practice Area",
                  data: invoice.practiceAreasId.toString(),
                ),
                InvoiceItemStatus(
                  name: _checkInvoiceStatus(),
                  bgColor: AppColors.primary,
                  horizontalPadding: 10,
                  verticalPadding: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _checkInvoiceStatus() {
    if (invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("submitted".toLowerCase())) {
      return "Submitted";
    }
    if (invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("edited".toLowerCase())) {
      return "Edited";
    }
    if (invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("rejected".toLowerCase())) {
      return "Rejected";
    }
    if (invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("returned".toLowerCase())) {
      return "Returned";
    }
    if (invoice.invoiceStatus2!.code
        .toLowerCase()
        .contains("approved".toLowerCase())) {
      return "Approved";
    }
    return "No Action";
  }
}
