import 'package:flutter/material.dart';
import 'package:smart_case/database/invoice/invoice_model.dart';
import 'package:smart_case/theme/color.dart';

class BankWidget extends StatelessWidget {
  final SmartInvoice invoice;

  const BankWidget({super.key, required this.invoice});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bank",
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              invoice.bank == null ? "N/A" : invoice.bank!.getName(),
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              invoice.bank == null || (invoice.bank != null && invoice.bank!.accountName == null)
                  ? "N/A"
                  : invoice.bank!.accountName!,
              style: TextStyle(
                  color: AppColors.darker, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if(invoice.bank != null && invoice.bank!.swiftCode != null) Text(
              invoice.bank == null || (invoice.bank != null && invoice.bank!.swiftCode == null)
                  ? "N/A"
                  : invoice.bank!.swiftCode!,
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              invoice.bank == null || (invoice.bank != null && invoice.bank!.accountNumber == null)
                  ? "N/A"
                  : invoice.bank!.accountNumber!,
              style: TextStyle(
                  color: AppColors.inActiveColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
